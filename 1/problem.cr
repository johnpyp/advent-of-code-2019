require "file"

input = File.read_lines("input.txt")
lines = input.map &.to_i

# part 1
puts lines.map { |x| x // 3 - 2 }.sum

# part 2
puts lines.map { |x|
  total = 0
  loop {
    x = x // 3 - 2
    break total if x <= 0
    total += x
  }
}.sum
