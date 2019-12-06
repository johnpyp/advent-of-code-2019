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

def input_to_map(input)
  input.each_with_object({} of String => String) { |x, map|
    a, b = x.split(')')
    map[b] = a
  }
end

def run(input)
  map = input_to_map(input)
  map.reduce(0) { |acc, x|
    k, v = x
    acc + collect_path(map, k).size
  }
end

def run2(input)
  map = input_to_map(input)
  san_path = collect_path map, "SAN"
  you_path = collect_path map, "YOU"
  shared = (san_path & you_path)[0]
  san_path.index(shared).as(Int32) + you_path.index(shared).as(Int32)
end

input = File.read_lines("input.txt")
puts run input
puts run2 input
