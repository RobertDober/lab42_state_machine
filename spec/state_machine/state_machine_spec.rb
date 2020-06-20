RSpec.describe Lab42::StateMachine do
  describe "The Null Machine (copying)" do
    let(:null_machine) { described_class.new("The Null Machine") }

    let(:nop) { -> (m, _) {m.to_s} }

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
    let(:iex_renumber) { described_class.new("Iex Renumber", copy_on_nil: true) }
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

    let(:renumber) do
    end
    before do
      iex_renumber.input = input.lazy
      iex_renumber.add(:start, %r{\A\s{4,}(?:iex|\.\.\.)\((\d+)\)>}, renumber)
      iex_renumber.run(0)
    end
  end
end

