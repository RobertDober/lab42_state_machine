require_relative 'state_machine/state.rb'
module Lab42
  class StateMachine

    attr_accessor :current, :input, :output
    attr_reader :designation, :options, :states


    def add(state, trigger, action, new_state=nil)
      s = states[state]
      s.add(trigger, action, new_state)
    end

    def run(accumulator=nil, input=nil)
      @input = input if input
      loop do
        accumulator = _transition(accumulator)
      end
    end

    def stop!
      raise StopIteration, "machine #{designation} stopped manually!"
    end


    private

    def initialize(name=nil, copy_on_nil: false)
      @options = {
        copy_on_nil: copy_on_nil,
      }
      @designation = name
      _init_vars
    end

    def _init_vars
      @output      = []
      @current     = :start
      @states      = Hash.new{ |h, k| h[k] = State.new(k) }
    end

    def _current_state
      states[current]
    end

    def _transition(accumulator)
      next_line = input.next
      output, accumulator, next_state = _current_state.transition(next_line, accumulator)
      @current = next_state
      if output
        @output << output
      elsif options[:copy_on_nil]
        @output << next_line
      end
    end

  end
end
