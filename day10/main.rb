require "set"

def main
  input = "input/input.txt"
  adapters = File.readlines(input).map { |i| i.chomp.to_i }.sort
  outlet = 0
  device = adapters.last + 3

  # Part 1
  jumps = [outlet, *adapters, device].each_cons(2).
    map { |a,b| b - a }.
    tally
  puts "Part One: #{jumps[1] * jumps[3]}"

  # Part 2
  nodes = Set[outlet, *adapters, device]
  paths = Hash.new { 0 }
  paths[outlet] = 1

  possible_jumps = [1,2,3]
  [outlet, *adapters].each do |node|
    # for each possible jump value, we check to see if there is an adapter that
    # fits the jump.
    possible_jumps.each do |jump|
      target = node + jump
      # If we can get to the target node from the current node, then we can add
      # all the paths to the current node to the target node path count.
      if nodes.include?(target)
        paths[target] += paths[node]
      end
    end
  end

  puts "Part Two: #{paths[device]}"

end

if __FILE__ == $PROGRAM_NAME
  main
end
