module Lab42
  class StateMachine
    class State
      attr_reader :designation, :triggers

      def add(trigger, action, new_state)
        new_state ||= designation
        @triggers << [trigger, action, new_state]
      end

      def transition(input, accumulator)
        triggers.each do |trigger, action, new_state|
          match = trigger.match(input)
          next unless match
          output, new_acc, new_state1 = action.(match, accumulator) 
          return [output, new_acc, new_state1 || new_state || designation] 
        end
        [input, accumulator, new_state || designation]
      end


      private

      def initialize(designation)
        @designation = designation
        @triggers    = []
      end
    end
  end
end
