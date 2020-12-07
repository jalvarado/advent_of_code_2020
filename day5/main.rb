def calculate_row(partition_map)
  row = partition_map.each_char.reduce((0..127).to_a) { |row_no, char| partition_range(char, row_no) }
  row.first
end

def calculate_column(partition_map)
  col = partition_map.each_char.reduce((0..7).to_a) { |col, char| partition_range(char, col) }
  col.first
end

def partition_range(f_or_b, range)
  return range if range.size == 1
  if f_or_b == "F" || f_or_b == "L"
    range[0...(range.size / 2).floor]
  elsif f_or_b == "B" || f_or_b == "R"
    range[(range.size / 2).ceil..-1]
  else
    raise "Invalid partition value: #{f_or_b}"
  end
end

def main
  # part one
  input  = File.readlines("input/input.txt").map(&:chomp)
  seats = input.map do |line|
    row = calculate_row(line[0..7])
    column = calculate_column(line[7..])
    seat_id = row * 8 + column
    [row,column, seat_id]
  end

  max_seat_id = seats.max_by { |s| s.last }
  puts "Part On3: MAx seat id = #{max_seat_id.last}"

  # Part Two
  seat_ids = seats.map(&:last)
  missing_seat_ids = (0..128*8).to_a - seat_ids
  my_seat = missing_seat_ids.detect { |id| seat_ids.include?(id + 1) && seat_ids.include?(id - 1) }
  puts "Part Two - My Seat Id: #{my_seat}"
end

if __FILE__ == $PROGRAM_NAME
  main
end
