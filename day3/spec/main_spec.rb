require_relative "../main"

RSpec.describe "day3" do
  describe "get_grid_item" do
    it "wraps around when moving to the right" do
      map = File.readlines("spec/fixtures/input.txt").map { |line| line.chomp.split("") }

      expect(get_grid_item(map, 0, 0)).to eq "."
      expect(get_grid_item(map, 0, 1)).to eq "."
      expect(get_grid_item(map, 0, 2)).to eq "#"
      expect(get_grid_item(map, 3, map.first.length - 1)).to eq "#"
      expect(get_grid_item(map, 3, map.first.length)).to eq "."
      expect(get_grid_item(map, 0, 14)).to eq "#"
    end
  end
end
