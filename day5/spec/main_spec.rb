require_relative "../main"

RSpec.describe "Day 5" do
  describe "Calculate row" do
    it "returns the correct row number" do
      input = "FBFBBFFRLR"
      expect(calculate_row(input[0..7])).to eq 44
    end

    it "works" do
      input = "BBBFFFFLLR"
      expect(calculate_row(input[0..7])).to eq 112
    end
  end

  describe "calculate col" do
    it "returns the correct row number" do
      input = "FBFBBFFRLR"
      expect(calculate_column(input[7..])).to eq 5
    end
  end
end
