require "file"

WIDTH  = 25
HEIGHT =  6
input = File.read_lines("input.txt")

layers = input[0].chars.map(&.to_i).each_slice(WIDTH*HEIGHT).to_a

# part 1
least0s = layers.min_by { |layer| layer.count(0) }
puts least0s.count(1) * least0s.count(2), ""
# part 2
final = layers.each_with_object(layers.first) { |layer, obj|
  layer.each_with_index { |x, i|
    obj[i] = x if obj[i] == 2
  }
}

HEIGHT.times {
  puts final[...WIDTH].join("").gsub("0", " ")
  final.delete_at(...WIDTH)
}
