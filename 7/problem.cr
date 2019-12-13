require "file"
require "../intcode"

input = File.read_lines("input.txt")
tape = input[0]

# part 1
puts (0..4).to_a.permutations.max_of { |perm|
  prev = 0
  perm.each { |setting|
    input = [setting, prev.to_i32]
    ic = IC.new tape
    ic.send(input)
    prev = ic.run || break
  }
  prev
}

# part 2
puts (5..9).to_a.permutations.max_of { |perm|
  map = {} of Int32 => IC
  prev = 0
  loop {
    res = prev
    perm.each { |setting|
      input = map.has_key?(setting) ? [prev.to_i32] : [setting, prev.to_i32]
      map[setting] ||= IC.new tape
      ic = map[setting]
      ic.send(input)
      prev = ic.run
      break if !prev
    }
    break res if !prev
  }
}
