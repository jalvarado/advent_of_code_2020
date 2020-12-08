def run_boot_sequence(instructions)
  accumulator = 0
  instruction_pointer = 0
  loop_detected = false
  loop do
    break if instruction_pointer >= instructions.length

    instruction = instructions[instruction_pointer]
    if instruction.empty?
      loop_detected = true
      break
    end

    # Remove executed commands
    instructions[instruction_pointer] = ""
    # Execute the instruction
    instruction_pointer, accumulator = execute_instruction(instruction, instruction_pointer, accumulator)
  end
  [loop_detected, accumulator]
end

def execute_instruction(instruction, instruction_pointer, accumulator)
    cmd, value = instruction.split(" ")
    case cmd
    when "nop"
      instruction_pointer += 1
    when "acc"
      accumulator += value.to_i
      instruction_pointer += 1
    when "jmp"
      instruction_pointer += value.to_i
    end
    [instruction_pointer, accumulator]
end

def get_execution_sequence(instructions)
  accumulator = 0
  instruction_pointer = 0
  loop_detected = false
  execution_sequence = []
  loop do
    break if instruction_pointer >= instructions.length

    instruction = instructions[instruction_pointer]
    if instruction.empty?
      loop_detected = true
      break
    end

    # Remove executed commands
    instructions[instruction_pointer] = ""
    # Execute the instruction
    execution_sequence.push([instruction_pointer, instruction])
    instruction_pointer, accumulator = execute_instruction(instruction, instruction_pointer, accumulator)
  end

  [loop_detected, execution_sequence]
end

def main
  #raw_instructions = File.readlines("input/test_input.txt").map(&:chomp)
  raw_instructions = File.readlines("input/input.txt").map(&:chomp)

  _, accumulator = run_boot_sequence(raw_instructions.dup)

  puts "Part One: Accumulator = #{accumulator}"

  # Part Two
  _loop_detected, initial_execution_sequence = get_execution_sequence(raw_instructions.dup)

  # the looping instruction is more likely to be towards the end of the
  # instruction sequence so go through the executed instructions in reverse
  # order
  (initial_execution_sequence.length - 1).downto(0).each do |execution_index|
    instruction_set = raw_instructions.dup
    i, instruction_to_modify = initial_execution_sequence[execution_index]

    cmd, _ = instruction_to_modify.split(" ")
    if cmd == "nop"
      instruction_set[i] = instruction_set[i].gsub("nop", "jmp")
    elsif cmd == "jmp"
      instruction_set[i] = instruction_set[i].gsub("jmp", "nop")
    else
      next
    end

    loop_detected, accumulator = run_boot_sequence(instruction_set.dup)

    if !loop_detected
      puts "Found sequence that correctly terminates"
      puts instruction_set
      puts "Accumulator = #{accumulator}"
      break
    end
  end
end


if __FILE__ == $PROGRAM_NAME
  main
end
