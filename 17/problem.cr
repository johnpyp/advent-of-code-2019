require "file"
require "math"
require "time"
require "random"
require "../intcode"
require "../util"
require "big"

record Point, x : Int32 = 0, y : Int32 = 0 {
  def man_distance
    x.abs + y.abs
  end

  def +(other)
    Point.new x + other.x, y + other.y
  end

  def -(other)
    Point.new x - other.x, y - other.y
  end
}

def surrounding(point)
  [
    point + Point.new(0, 1),
    point + Point.new(0, -1),
    point + Point.new(-1, 0),
    point + Point.new(1, 0),
  ]
end

def run1(input)
  ic = IC.new input
  outp = ic.collect
  x = 0
  y = 0
  hm = outp.each_with_object({} of Point => Char) { |n, obj|
    c = n.chr
    if c == '\n'
      y += 1
      x = 0
      next
    end
    obj[Point.new(x, y)] = c
    x += 1
  }
  scaffold_points = hm.select { |k, v| v == '#' }.keys
  intersect_points = scaffold_points.select { |point|
    surrounding(point).count { |new_point| hm[new_point]? == '#' } >= 3
  }
  intersect_points.each { |point|
    hm[point] = 'O'
  }
  Util.print_point_map(hm) { |r, c, v|
    v
  }
  intersect_points.map { |point|
    point.x * point.y
  }.sum
end

def run2(input)
  input = "2" + input[1..]
end

input = File.read("input.txt").strip
puts run1(input)
# puts run2(input)
