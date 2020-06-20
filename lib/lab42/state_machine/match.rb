require "forwarder"
module Lab42
  class StateMachine
    class Match
      StateError = Class.new RuntimeError
      extend Forwarder

      attr_reader :groups, :rgx

      forward :[], to: :@match

      Parts = {
        pre: 0,
        prefix: 0,
        first: 0,
        first_match: 1,
        first_capture: 2,
        suffix: -1,
        last: -1,
        last_match: -2,
        last_capture: -3
      }

      def match(with=nil)
        return @match unless with
        raise StateError, "must not match twice" if @match
        @match = @rgx.match(with)
        _set_wrapping_data with if @match
        self
      end

      def matched?
        !!@match
      end

      def replace_part(prt, with=nil, &blk)
        prt1 = _resolve_prt(prt)
        @parts[prt1] =
          if blk
            blk.(@parts[prt1])
          else
            with
          end
        self
      end

      def replace(grp, with=nil, &blk)
        @parts[grp*2] =
          if blk
            blk.(@parts[grp*2])
          else
            with
          end
        self
      end

      def string
        @parts.join
      end

      private
      def initialize(rgx, input = nil)
        @rgx = rgx
        @match = nil
        @groups = nil
        match(input) if input
      end

      def _resolve_prt(prt)
        case prt
        when Integer
          prt
        else
          Parts.fetch(prt){
            raise ArgumentError, "undefined part #{prt.inspect} use one of: #{Parts.keys.inspect}"
          }
        end
      end

      def _set_wrapping_data(string)
        @parts = [@match.pre_match, string[@match.begin(0)...@match.begin(1)]]
        (1...@match.size.pred).each do |capture_index|
          @parts << @match[capture_index]
          @parts << string[@match.end(capture_index)...@match.begin(capture_index.succ)]
        end
        @parts << @match[-1]
        @parts << string[@match.end(@match.size.pred)...@match.end(0)]
        @parts << @match.post_match
        @groups = @match[0...@match.size]
      end
    end
  end
end
