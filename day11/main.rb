def main
  # input = File.readlines("./input/test_input.txt").map { |r| r.chomp.split("") }
  input = File.readlines("./input/input.txt").map { |r| r.chomp.split("") }
  seats = input.dup
  previous_seats = nil

  puts "Evolving seats"
  while seats != previous_seats
    previous_seats = seats
    seats = evolve(seats)
  end

  puts "Filled Seats: #{seats.flatten.tally.fetch('#', 0)}"

  ## Part 2
  seats = input.dup
  previous_seats = nil

  while seats != previous_seats
    #print_board(seats)
    previous_seats = seats
    seats = evolve_los(seats)
  end

  #print_board(seats)
  puts "Part 2 Filled Seats: #{seats.flatten.tally.fetch('#', 0)}"
end

def print_board(seats)
  seats.map { |row| pp row.join }
  puts
end

def evolve_los(seats)
  seats.dup.each_with_index.map do |row, y|
    row.each_with_index.map do |seat, x|
      filled_neighbor_count = los_neighbors(seats, x, y)

      if seat == "L" && filled_neighbor_count.zero?
        "#"
      elsif seat == "#" && filled_neighbor_count >= 5
        "L"
      else
        seat
      end
    end
  end
end

def evolve(seats)
  seats.dup.each_with_index.map do |row, y|
    row.each_with_index.map do |seat, x|
      filled_neighbor_count = filled_neighbors(seats, x, y)

      if seat == "L" && filled_neighbor_count.zero?
        "#"
      elsif seat == "#" && filled_neighbor_count >= 4
        "L"
      else
        seat
      end
    end
  end
end

def los_neighbors(seats, x, y)
  directions = [
    [-1,-1],
    [-1,0],
    [-1,1],
    [0,-1],
    [0,1],
    [1,-1],
    [1,0],
    [1,1],
  ]

  directions.map do |dx, dy|
    new_x = x + dx
    new_y = y + dy

    char = nil
    loop do
      if new_x < 0 || new_x >= seats.first.length || new_y < 0 ||
          new_y >= seats.length
        break
      end

      if seats[new_y][new_x] != "."
        char = seats[new_y][new_x]
        break
      end

      # We didn't see a filled or empty seat so check the next in the LOS
      new_x = new_x + dx
      new_y = new_y + dy
    end
    char
  end.tally.fetch("#", 0)
end

def filled_neighbors(seats, x,y)
  neighbor_offsets = [
    [-1,-1],
    [-1,0],
    [-1,1],
    [0,-1],
    [0,1],
    [1,-1],
    [1,0],
    [1,1],
  ]
  neighbor_offsets.map { |dx, dy|
    if (x + dx < 0) || (x + dx >= seats.first.length) ||
      (y + dy < 0) || (y + dy >= seats.length)
      nil
    else
      seats[y + dy][x + dx]
    end
  }.tally.fetch("#", 0)
end


if __FILE__ == $PROGRAM_NAME
  main
end
