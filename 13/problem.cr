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
  x, y, tile = ic1.collect_safe(3) || break
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
  joystick_tilt = case
                  when ball_pos > paddle_pos  then 1
                  when ball_pos < paddle_pos  then -1
                  when ball_pos == paddle_pos then 0
                  else                             raise "Unexpected"
                  end
  ic2.send joystick_tilt
  x, y, tile = ic2.collect_safe(3) || break
  ball_pos = x if tile == 4
  paddle_pos = x if tile == 3
  if {x, y} == {-1, 0}
    puts "score #{tile}"
  else
    puts "x #{x}, y #{y}, tile #{tile}"
  end
}
