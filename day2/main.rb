# frozen_string_literal: true

def valid_password_count(lines)
  lines.select { |line| valid_password?(line) }.count
end

def valid_password?(line)
  line_regex = /(\d+)-(\d+) ([a-z]): ([a-z]*)/
  if (match = line.match(line_regex))
    min, max, char, password = match.captures
    char_count = password.count(char)
    char_count >= min.to_i && char_count <= max.to_i
  else
    puts 'Did not match regex'
    puts line
  end
end

def valid_password_count_by_index(lines)
  lines.select { |line| valid_password_by_index?(line) }.count
end

def valid_password_by_index?(line)
  line_regex = /(\d+)-(\d+) ([a-z]): ([a-z]*)/
  if (match = line.match(line_regex))
    first_index, second_index, char, password = match.captures
    (password[first_index.to_i - 1] == char) ^ (password[second_index.to_i - 1] == char)
  else
    puts 'Did not match regex'
    puts line
  end
end

def main
  lines = File.readlines('./input/input.txt')
  puts "Part One: #{valid_password_count(lines)}"
  puts "Part Two: #{valid_password_count_by_index(lines)}"
end

main if __FILE__ == $PROGRAM_NAME
