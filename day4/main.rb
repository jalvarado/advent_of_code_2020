def valid_passport?(passport, validate_data = false)
  has_required_keys?(passport) && (!validate_data || has_valid_data?(passport))
end

def has_required_keys?(passport)
  required_keys = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
  required_keys.all? { |k| passport.key?(k) }
end

def has_valid_data?(passport)
  required_keys = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
  required_keys.all? { |k| passport[k] && send("validate_#{k}", passport[k]) }
end

def validate_byr(year)
  year.length == 4 && (year.to_i >= 1920 && year.to_i <= 2002)
end

def validate_iyr(year)
  year.length == 4 && (year.to_i >= 2010 && year.to_i <= 2020)
end

def validate_ecl(color)
  ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].include?(color)
end

def validate_pid(pid)
  pid.match?(/\A\d{9}\z/)
end

def validate_eyr(year)
  year.length == 4 && (year.to_i >= 2020 && year.to_i <= 2030)
end

def validate_hcl(color)
  color.match?(/#[0-9a-f]{6}/)
end

def validate_hgt(height)
  if match = height.match(/(\d+)(in|cm)/)
    h = match.captures.first.to_i
    if match.captures.last == "in"
      h >= 59 && h <= 76
    else
      h >= 150 && h <= 193
    end
  else
    false
  end
end

def parse_passport_batch(filename)
  input_lines = File.readlines(filename).map(&:chomp)
  grouped_input = input_lines.slice_before("").to_a
  grouped_input.map! { |g| g.join(" ").strip }

  line_regex = /(?<key>[a-z]{3}):(?<value>\S+)\b/
  grouped_input.map! do |line|
    matches = line.scan(line_regex)
    Hash[ matches ]
  end

  grouped_input
end

def main
  passports = parse_passport_batch("input/input.txt")

  # Part One
  valid_count = passports.map { |passport| valid_passport?(passport) ? 1 : 0 }.
    reduce(&:+)
  puts "Part One Valid passports: #{valid_count}"

  # Part Two
  valid_count = passports.map { |passport| valid_passport?(passport, true) ? 1 : 0 }.
    reduce(&:+)
  puts "Part Two Valid passports: #{valid_count}"
end

if __FILE__ == $PROGRAM_NAME
  main
end
