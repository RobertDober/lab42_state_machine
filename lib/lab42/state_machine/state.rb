require "lab42/match"
module Lab42
  class StateMachine
    class State
      attr_reader :designation, :triggers

      def add(trigger, action, new_state)
        trigger = Lab42::Match.new(trigger) if Regexp === trigger
        new_state ||= designation
        @triggers << [trigger, action, new_state]
      end

      def transition(accumulator, input)
        triggers.each do |trigger, action, new_state|
          match = _match input, trigger
          next unless match
          output, new_acc, new_state1 = _apply(match, accumulator, input: input, to: action)
          output = output.string if Lab42::Match === output
          return [output, new_acc || accumulator, new_state1 || new_state || designation]
        end
        [input, accumulator, designation]
      end

      def _match(input, trigger)
        case trigger
        when Lab42::Match
          m =trigger.match(input)
          m.success? && m
        when TrueClass
          true
        when FalseClass
          raise StopIteration
        when Symbol
          input.send trigger
        end
      end

      def freeze
        super
        @triggers.freeze
      end

      private

      def _apply(match, accumulator, input:, to:)
        if to
          case to.arity
          when 1
            to.(match)
          when 2
            to.(accumulator, match)
          else
            raise ArgumentError, "#{to} needs to accept one or two parameters , as it is a State's action"
          end
        else
          input
        end
      end

      def initialize(designation)
        @designation = designation
        @triggers    = []
      end
    end
  end
end
