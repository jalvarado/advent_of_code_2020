def get_grid_item(grid, y, x)
  grid[y][x % grid[y].length]
end

def count_trees(map, delta_x, delta_y)
  x = 0
  y = 0
  tree_count = 0

  while y < map.size do
    grid_item = get_grid_item(map, y, x)
    # puts "(x: #{x}, y: #{y}) - #{grid_item}"

    if grid_item == "#"
      tree_count += 1
    end

    x += delta_x
    y += delta_y
  end

  tree_count
end

def main
  map = File.readlines("input/input.txt").map { |line| line.chomp.split("") }
  tree_count = count_trees(map, 3, 1)
  puts "Slope (x: 3, y: 1), Tree Count: #{tree_count}"

  # part two
  slopes = [
    [1, 1],
    [3, 1],
    [5, 1],
    [7, 1],
    [1, 2],
  ]
  trees = slopes.map { |delta_x, delta_y| count_trees(map, delta_x, delta_y) }
  puts "Tree Counts: #{trees}"
  trees_multiplied = trees.reduce(:*)
  puts "Part Two: #{trees_multiplied}"
end

if __FILE__ == $PROGRAM_NAME
  main
end
