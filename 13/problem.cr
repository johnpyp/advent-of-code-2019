require "file"
require "math"
require "time"
require "random"
require "../intcode"
require "../util"

record Point, x : Int64 = 0_i64, y : Int64 = 0_i64 {
  def man_distance
    x.abs + y.abs
  end

  def +(other)
    Point.new x + other.x, y + other.y
  end
}

input = File.read("input.txt").strip

# Part 1
hm = {} of Point => Int64
ic1 = IC.new input
loop {
  x = ic1.run || break
  y = ic1.run || break
  tile = ic1.run || break
  hm[Point.new x, y] = tile
}
puts hm.values.count(2)

Util.print_point_map(hm) { |x, y, v|
  case v
  when 0 then "~"
  when 1 then "#"
  when 2 then "M"
  when 3 then "_"
  when 4 then "o"
  else        raise "Unexpected"
  end
}
# Part 2
input2 = "2" + input[1..]
ic2 = IC.new input2
ball_pos = 0
paddle_pos = 0
loop {
  jpos = case
         when ball_pos > paddle_pos  then 1
         when ball_pos < paddle_pos  then -1
         when ball_pos == paddle_pos then 0
         else                             raise "Unexpected"
         end
  x = ic2.run(jpos) || break
  y = ic2.run || break
  tile = ic2.run || break
  ball_pos = x if tile == 4
  paddle_pos = x if tile == 3
  if x == -1 && y == 0
    puts "score #{tile}"
  else
    puts "x #{x}, y #{y}, tile #{tile}"
  end
}
