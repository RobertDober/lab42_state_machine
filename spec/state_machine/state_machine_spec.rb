RSpec.describe Lab42::StateMachine do
  let(:nop) { -> (s) {s} }

  describe "The Null Machine (copying)" do
    let(:null_machine) { described_class.new("The Null Machine") }
    before do
      null_machine.input = %w[alpha beta].lazy
      null_machine.add(:start, %r{.*}, nop)
    end

    it "copies input to output" do
      null_machine.run
      expect( null_machine.output ).to eq( %w[alpha beta] ) 
    end
  end

  describe "A pratical example" do
    let(:input) do 
      [
        "defmodule X do",
        "",
        "   @doc'''",
        "       iex(3)> hello",
        "       ...(4)> world",
        "",
        "...",
        "       ...(3)> alpha",
        "       iex(2)> beta"
      ]
    end
    let(:expected) do
      [
"defmodule X do",
"",
"   @doc'''",
"       iex(1)> hello",
"       ...(1)> world",
"",
"...",
"       iex(2)> alpha",
"       ...(2)> beta",
      ]
    end

    let(:renumber1) do
      -> (acc, match) do
        [ match
            .replace(1, "iex")
            .replace(2, acc.succ)
            .string,
          acc.succ ]
      end
    end
    let(:renumber2) do
      -> (acc, match) do
        match
          .replace(1, "...")
          .replace(2, acc)
          .string
      end
    end

    context "functional API" do
      let(:iex_renumber) { described_class.new("Iex Renumber", copy_on_nil: true) }
      before do
        iex_renumber.input = input.lazy
        iex_renumber.add(:start, %r{\A\s{4,}(iex|\.\.\.)\((\d+)\)>}, renumber1, :iex)
        iex_renumber.add(:iex,   %r{\A\s{4,}(iex|\.\.\.)\((\d+)\)>}, renumber2) 
        iex_renumber.add(:iex,   %r{.}, nop, :start) 
        iex_renumber.run(0)
      end

      it "renumbers the output" do
        expect(iex_renumber.output).to eq(expected)
      end
    end

    context "DSL" do
      let(:iex_renumber) do
        described_class.new("Iex Renumber", copy_on_nil: true) do
          state :start do
            trigger %r{\A\s{4,}(iex|\.\.\.)\((\d+)\)>}, :iex do |acc, match|
              [ match
                  .replace(1, "iex")
                  .replace(2, acc.succ)
                  .string,
                acc.succ ]
            end
          end
          state :iex do
            trigger %r{\A\s{4,}(iex|\.\.\.)\((\d+)\)>} do |acc, match|
              match
                .replace(1, "...")
                .replace(2, acc)
                .string
            end
            trigger true, :start
          end
        end
      end
      before do
        iex_renumber.run(0, input.lazy)
      end

      it "renumbers the output" do
        expect(iex_renumber.output).to eq(expected)
      end
    end
  end
end

