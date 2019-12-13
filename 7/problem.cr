require "file"
require "../intcode"

input = File.read_lines("input.txt")
tape = input[0]

# part 1
puts (0..4).to_a.permutations.max_of { |perm|
  prev = 0
  perm.each { |setting|
    ic = IC.new tape
    ic.send(setting)
    ic.send(prev)
    prev = ic.run || break
  }
  prev
}

# part 2
puts (5..9).to_a.permutations.max_of { |perm|
  map = {} of Int32 => IC
  perm.each { |setting|
    ic = IC.new tape
    ic.send(setting)
    map[setting] = ic
  }
  prev = 0
  count = 0
  loop {
    setting = perm[count % perm.size]
    ic = map[setting]
    ic.send(prev)
    prev = ic.run || break prev
    count += 1
  }
}
