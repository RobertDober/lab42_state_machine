require "lab42/state_machine/match"
RSpec.describe Lab42::StateMachine::Match do

  subject{ described_class.new(regex) }
  let(:regex) { %r{\A(\s*)\w+\s+(.*)\z} }
  
  it "one can access it's regex again" do
    expect( subject.rgx ).to eq(regex)
  end

  shared_examples_for "no match" do
    it "is not matched yet" do
      expect( subject ).not_to be_matched
    end

    it "returns a nil match" do
      expect( subject.match ).to be_nil
    end

    it "groups are undefined" do
      expect{ subject[0] }.to raise_error(NoMethodError)
    end

    it "as I said, they are" do
      expect( subject.groups ).to be_nil
    end
  end

  describe "new instance" do
    it_behaves_like "no match"
  end

  describe "missmatches (no not a girl selling selfinflaming mini sticks)" do
    let(:input){ "thisdoesnotmatch" }
    before do
      subject.match(input)
    end
    it_behaves_like "no match"
  end

  describe "matched instance" do

    let(:input) { "  hello world" }

    before do
      subject.match(input)
    end
    context "access" do
      it "is matched now" do
        expect( subject ).to be_matched
      end
      it "has a MatchData object" do
        expect( subject.match ).to be_kind_of(MatchData)
      end
      it "has all the groups" do
        expect( subject.groups ).to eq([input, "  ", "world"])
      end
      it "has the string" do
        expect( subject.string ).to eq(input)
      end
    end

    context "modifications" do
      before do
        subject.replace(1, "--")
      end
      it "has been replaced in the string" do
        expect( subject.string ).to eq("--hello world")
      end
      it "we can chain that" do
        subject.replace(1, "*").replace(2, "---")
        expect( subject.string ).to eq("*hello ---")
      end
    end
  end

  describe "specifying all the edge cases" do
    let(:rgx) { %r{\w-(\d+)\s+(\d+)\s+} }
    let(:input) { ">>>A-42 43 <<<" }
    subject{ described_class.new(rgx, input) }

    it "in the beginning" do
      expect( subject.string ).to eq(input)
    end

    it "let us change one group" do
      expect( subject.replace(1, "43").string ).to eq(">>>A-43 43 <<<")
    end

    it "the block form is great, and chaining is too" do
      expect( subject.replace(1){|x| x.to_i * 2}.replace(2, "").string ).to eq(">>>A-84  <<<")
    end

    context "let us access the first part" do
      it "as pre" do
        expect( subject.replace_part(:pre, "").string ).to eq("A-42 43 <<<")
      end

      it "as prefix" do
        expect( subject.replace_part(:prefix, "").string ).to eq("A-42 43 <<<")
      end

      it "with 0" do
        expect( subject.replace_part(0, "").string ).to eq("A-42 43 <<<")
      end

      it "typos are not tolerated as pefix" do
        expect{ subject.replace_part(:pefix, "").string }.to raise_error(ArgumentError, %r{undefined part :pefix})
      end
    end

    context "crazy change everything" do
      it "indeed" do
        subject
          .replace(1){ |x| x + x}
          .replace_part(:suffix){ |x| x[0] }
          .replace_part(3, "<--->")
          .replace(2, "*")
          .replace_part(:last_match, ".")
        expect( subject.string ).to eq(">>>A-4242<--->*.<")
      end
    end
  end






end
