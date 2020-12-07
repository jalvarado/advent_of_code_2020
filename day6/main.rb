require "set"

def main
  input_lines = File.readlines("input/input.txt").map(&:chomp)
  #input_lines = File.readlines("input/test.txt").map(&:chomp)

  # Part One
  puts input_lines.
    slice_before("").
    to_a.
    map {|g| g.map {|s| s.split("") } }.
    map {|g| g.flatten.uniq }.
    reduce(0) {|acc, letters| acc += letters.size }

  # Part Two
  puts input_lines.
    slice_before("").
    to_a.
    map { |answer_group| answer_group.reject { |a| a.empty? } }.
    map { |answer_group| answer_group.map { |p_answer| p_answer.split("").to_set } }.
    map { |answer_group| answer_group.reduce {|all_yes, answer_set| all_yes.intersection(answer_set) } }.
    reduce(0) { |sum, all_yes_set| sum += all_yes_set.size }
    inspect

end

if __FILE__ == $PROGRAM_NAME
  main
end
