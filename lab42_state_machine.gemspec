$:.unshift( File.expand_path( "../lib", __FILE__ ) )
require 'lab42/state_machine/version'
version = Lab42::StateMachine::VERSION
Gem::Specification.new do |s|
  s.name        = 'lab42_state_machine'
  s.version     = version
  s.summary     = 'Define triggers and transitios, what else?'
  s.description = %{Define triggers and transitios, what else? Well... Filter} 
  s.authors     = ["Robert Dober"]
  s.email       = 'robert.dober@gmail.com'
  s.files       = Dir.glob("lib/**/*.rb")
  s.files      += %w{LICENSE README.md}
  s.homepage    = "https://github.com/RobertDober/lab42_state_machine"
  s.licenses    = %w{Apache 2}

  s.required_ruby_version = '>= 2.7.0'
  s.add_dependency 'forwarder2', '~> 0.2'
  s.add_dependency 'lab42_match', '~> 0.1.1'
  # s.add_dependency 'lab42_function', '~> 0.1'

  # s.add_development_dependency 'pry', '~> 0.11'
  s.add_development_dependency 'pry-byebug', '~> 3.9'
  s.add_development_dependency 'pry-doc', '~> 1.1.0'
  s.add_development_dependency 'rspec', '~> 3.9'
  s.add_development_dependency 'speculate_about', '~> 0.2'
  s.add_development_dependency 'simplecov', '~> 0.15'

  s.add_development_dependency 'codeclimate-test-reporter', '~> 1.0'

  s.add_development_dependency 'travis-lint', '~> 2.0'
  # s.add_development_dependency 'rake', '~> 10.3'
end
