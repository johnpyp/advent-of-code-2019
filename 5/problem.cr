require "file"
require "../intcode"

input = File.read_lines("input.txt")
tape = input[0]
ic = IC.new tape
loop {
  puts ic.run(1) || break
}
puts IC.run tape, 5
