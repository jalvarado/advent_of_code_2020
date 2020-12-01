# frozen_string_literal: true

def find_sum_to_2020(input)
  input.combination(2).lazy.detect { |a, b| a + b == 2020 }
end

def find_triple_sum_to_2020(input)
  input.combination(3).lazy.detect { |i| i.sum == 2020 }
end

def read_input(path)
  IO.readlines(path, chomp: true).map(&:to_i)
end

def day1
  input = read_input('./input/input.txt')
  a, b = find_sum_to_2020(input)
  puts "[#{a}, #{b}]: #{a * b}"

  a, b, c = find_triple_sum_to_2020(input)
  puts "[#{a}, #{b}, #{c}]: #{a * b * c}"
end

day1 if __FILE__ == $PROGRAM_NAME
