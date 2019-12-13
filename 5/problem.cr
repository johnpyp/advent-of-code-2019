require "file"
require "../intcode"

input = File.read_lines("input.txt")
tape = input[0]
puts IC.run tape, 1
puts IC.run tape, 5
