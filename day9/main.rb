def main
  input = File.readlines("input/input.txt").map(&:chomp).map(&:to_i)

  # Part One
  preamble_length = 25
  invalid_number = nil
  input[preamble_length..].each_with_index do |num, index|
    preamble = input[index..index+preamble_length]
    sums = preamble.combination(2).map(&:sum)

    if !sums.include?(num)
      invalid_number = num
      puts "Invalid number: #{num}"
      break
    end
  end

  # Part Two
  _n, max_index = input.each_with_index.detect { |n, i| n >= invalid_number }

  low_index = 0
  high_index = low_index + 1
  while low_index <= max_index - 1
    range = input[low_index...high_index]
    puts "Checking (#{low_index}...#{high_index}) #{range.sum}"
    if range.sum == invalid_number
      puts "Found range: #{range.inspect}"
      puts "Part Two: #{range.min + range.max}"
      break
    end


    if high_index == max_index
      low_index += 1
      high_index = low_index + 1
    else
      high_index += 1
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  main
end
