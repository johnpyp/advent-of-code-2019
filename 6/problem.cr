require "file"

def collect_path(map, key, end_point = "COM")
  key = key.clone
  path = [] of String
  loop {
    nex = map[key]
    path.push(nex)
    if nex == end_point
      break
    else
      key = nex
    end
  }
  path
end

input = File.read_lines("input.txt")
map = input.each_with_object({} of String => String) { |x, obj|
  a, b = x.split(')')
  obj[b] = a
}
# part 1
puts map.reduce(0) { |acc, x|
  k, _ = x
  acc + collect_path(map, k).size
}
# part 2
san_path = collect_path map, "SAN"
you_path = collect_path map, "YOU"

shared = (san_path & you_path)[0]

puts san_path.index(shared).not_nil! + you_path.index(shared).not_nil!
