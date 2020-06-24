
# Lab42::StateMachine

[![Build Status](https://travis-ci.org/RobertDober/lab42_state_machine.svg?branch=master)](https://travis-ci.org/RobertDober/lab42_state_machine)
[![Gem Version](https://badge.fury.io/rb/lab42_state_machine.svg)](http://badge.fury.io/rb/lab42_state_machine)
[![Code Climate](https://codeclimate.com/github/RobertDober/lab42_state_machine/badges/gpa.svg)](https://codeclimate.com/github/RobertDober/lab42_state_machine)
[![Issue Count](https://codeclimate.com/github/RobertDober/lab42_state_machine/badges/issue_count.svg)](https://codeclimate.com/github/RobertDober/lab42_state_machine)
[![Test Coverage](https://codeclimate.com/github/RobertDober/lab42_state_machine/badges/coverage.svg)](https://codeclimate.com/github/RobertDober/lab42_state_machine)

## Usage

### The DSL

Define a State Machine by giving it a name and defining states with their transitions in a block:

Example: A Simple Definition

```ruby :example 
    Lab42::StateMachine.new "my machine" do
      state :start do
        trigger %r{\A[aeiou]} do |acc, _|
           [nil, [acc.first+1, acc.last]]
         end
      end
    end
```

Be aware that a trigger block needs to accept at least one argument

Example: This raises an ArgumentError

```ruby :example
  machine = 
    Lab42::StateMachine.new "my machine" do
      state :start do
        trigger %r{\A[aeiou]} do
           [nil, nil]
         end
      end
    end
  expect{ machine.run(nil, ["abc"]) }.to raise_error(ArgumentError)
```

Also there is one state you must not defined, the `:stop` state

Example: Defining the `:stop` state

```ruby :example
   expect do
     Lab42::StateMachine.new "booom, don't stop" do
        state :stop do
          trigger true, :start
        end
     end
   end.to raise_error(FrozenError)
    
```






## Author

Copyright © 2020 Robert Dober
mailto: robert.dober@gmail.com

# LICENSE

Same as Elixir -- &#X1F609; --, which is Apache License v2.0. Please refer to [LICENSE](LICENSE) for details.

SPDX-License-Identifier: Apache-2.0

