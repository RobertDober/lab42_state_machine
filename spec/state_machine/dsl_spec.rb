RSpec.describe Lab42::StateMachine do

  context "illegal monitor state" do
    it "must not call trigger outside of state" do
      expect do
        described_class.new("bad example (tribute to Jack O'Neill with two Ls)") do
          trigger %r{.}
        end
      end.to raise_error(Lab42::StateMachine::DSL::IllegalMonitorState)
    end
  end

  context "the adder" do
    let :the_adder do
      described_class.new "adding odds and evens" do
        state :start do
          trigger %r{(\d*[02468])\s*\z} do |acc, match|
            [nil, [acc.first + match[1].to_i, acc.last]]
          end
          trigger %r{(\d*[13579])\s*\z} do |acc, match|
            [nil, [acc.first, acc.last + match[1].to_i]]
          end
        end
      end
    end
    let(:input) { %w[1 hello hello42 3 2] }

    it "just works" do
      expect( the_adder.run([0, 0], input) ).to eq([44, 4])
    end
  end

  describe "stopping the state machine" do
    context "immideately" do
      let :the_counter do
        described_class.new "the counter" do
          state :start do
            trigger %r{\A\w} do |acc, _|
              [nil, acc + 1]
            end
            trigger false
          end
        end
      end
      let(:input) { [ "hello", "world", "", "ignored" ] }

      it "ignores what needs to be ignored" do
        expect( the_counter.run(0, input) ).to eq(2)
      end
    end
    context "inside an action" do
      let :the_counter do
        described_class.new "the counter" do
          state :start do
            trigger %r{\A\w} do |acc, _|
              [nil, acc + 1]
            end
            trigger :empty? do |acc, _ |
              [nil, acc + 1, :stop]
            end
          end
        end
      end
      let(:input) { [ "hello", "world", "", "ignored", "really ignored" ] }

      it "ignores what needs to be ignored" do
        expect( the_counter.run(0, input) ).to eq(3)
      end
    end
  end
end

