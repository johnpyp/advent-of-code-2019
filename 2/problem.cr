require "file"
require "../intcode"

input = File.read_lines("input.txt")
base_tape = input[0].split(',').map &.to_i

# part 1
tape = base_tape.clone
tape[1], tape[2] = [12, 2]
ic = IC.new tape
ic.run
puts ic.t[0]

# part 2
correct = 19690720
puts 100.times.to_a.permutations(2).find { |x|
  t = base_tape.clone
  t[1], t[2] = x
  ic = IC.new t
  ic.run
  ic.t[0] == correct
}
