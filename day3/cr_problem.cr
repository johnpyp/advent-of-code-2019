#!/bin/crystal run
require "file"

record Point, x : Int32 = 0, y : Int32 = 0 {
  def man_distance
    x.abs + y.abs
  end

  def +(other)
    Point.new x + other.x, y + other.y
  end
}

def parse_command(command)
  op = command[0]
  amount = command[1..].to_i
  return get_delta(op), amount
end

def get_delta(op)
  case op
  when 'U' then Point.new 0, 1
  when 'D' then Point.new 0, -1
  when 'R' then Point.new 1, 0
  when 'L' then Point.new -1, 0
  else          Point.new 0, 0
  end
end

def parse_line(line)
  commands = line.split(',').map { |x| parse_command(x) }
  points = [] of Point
  pos = Point.new
  commands.each { |c|
    c[1].times {
      pos += c[0]
      points.push(pos)
    }
  }
  points
end

input = File.read_lines("input.txt")
points1 = parse_line(input[0])
points2 = parse_line(input[1])

intersect_points = (points1 & points2).select { |x| x != Point.new }

# part 1
puts intersect_points.min_of &.man_distance

# part 2
puts intersect_points.min_of { |p| (points1.index(p) || 0) + (points2.index(p) || 0) }
