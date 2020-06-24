module Lab42
  class StateMachine
    class DSL
      IllegalMonitorState = Class.new RuntimeError

      attr_reader :current_state, :machine

      def state designation, &blk
        @current_state = designation
        instance_eval(&blk)
      end

      def trigger trigger_exp, new_state = nil, &blk
        raise IllegalMonitorState unless current_state
        machine.add(current_state, trigger_exp, blk, new_state)
      end


      private

      def initialize machine, &blk 
        @machine = machine
        instance_eval(&blk)
      end
    end
  end
end
