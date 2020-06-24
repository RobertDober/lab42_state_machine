require "lab42/match"
module Lab42
  class StateMachine
    class State
      attr_reader :designation, :triggers

      def add(trigger, action, new_state)
        trigger = Lab42::Match.new(trigger) unless Lab42::Match === trigger
        new_state ||= designation
        @triggers << [trigger, action, new_state]
      end

      def transition(input, accumulator)
        triggers.each do |trigger, action, new_state|
          match = trigger.match(input)
          next unless match.success?
          output, new_acc, new_state1 = _apply(match, accumulator, to: action) 
          output = output.string if Lab42::Match === output
          return [output, new_acc || accumulator, new_state1 || new_state || designation] 
        end
        [input, accumulator, new_state || designation]
      end


      private

      def _apply(match, accumulator, to:)
        case to.arity
        when 1
          to.(match)
        when -1
          to.(accumulator, *match.parts)
        when 0
          # TODO: Move this check to  #add ?
          raise ArgumentError, "#{to} needs to accept at least one param, as it is a State's action"
        else
          to.(accumulator, match)
        end
      end

      def initialize(designation)
        @designation = designation
        @triggers    = []
      end
    end
  end
end
