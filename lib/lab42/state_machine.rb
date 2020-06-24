require_relative 'state_machine/state.rb'
require_relative 'state_machine/dsl.rb'
module Lab42
  class StateMachine

    attr_accessor :current, :input, :output
    attr_reader :designation, :options, :states


    def add(state, trigger, action, new_state=nil)
      s = states[state]
      s.add(trigger, action, new_state)
    end

    def run(accumulator=nil, input=nil)
      if input
        @input = input
        @input = input.enum_for(:each) unless Enumerator === input
      end
      loop do
        accumulator = _transition(accumulator)
      end
      accumulator
    end


    private

    def initialize(name=nil, copy_on_nil: false, &blk)
      @options = {
        copy_on_nil: copy_on_nil,
      }
      @designation = name
      _init_vars
      _define_machine blk
    end

    def _init_stop_state
      add(:stop, true, ->(_){ raise StopIteration })
      @states[:stop].freeze
    end

    def _init_vars
      @output      = []
      @current     = :start
      @states      = Hash.new{ |h, k| h[k] = State.new(k) }
      _init_stop_state
    end

    def _current_state
      states[current]
    end

    def _define_machine blk
      return unless blk
      DSL.new(self, &blk)
    end

    def _transition(accumulator)
      next_line = input.next
      output, accumulator, next_state = _current_state.transition(accumulator, next_line)
      @current = next_state
      if output
        @output << output
      elsif options[:copy_on_nil]
        @output << next_line
      end
      accumulator
    end

  end
end
