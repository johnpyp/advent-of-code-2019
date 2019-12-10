require "file"
require "math"

record Point, x : Int32 = 0, y : Int32 = 0 {
  def dist(other)
    Math.sqrt((other.x - x) ** 2 + (other.y - y) ** 2)
  end

  def slope(other)
    (other.y - y) / (other.x - x)
  end

  def ang(other)
    theta = (Math.atan2(other.y - y, other.x - x) * (180 / Math::PI) + 90) % 360
    theta
  end
}

record PPair, p1 : Point, p2 : Point {
  def slope
    s = p1.slope(p2)
    p2.x < p1.x ? s + 0.000001 : s
  end

  def dist
    p1.dist(p2)
  end

  def ang
    p1.ang(p2)
  end
}

def input_to_points(i)
  points = [] of Point
  i.each_with_index { |row, r|
    row.chars.each_with_index { |char, c|
      if char == '#'
        points << Point.new c, r
      end
    }
  }
  points
end

def run1(i)
  points = input_to_points i

  points.map { |p1|
    {points
      .map { |p2| PPair.new p1, p2 }
      .uniq(&.slope)
      .size, p1}
  }.max_by(&.[0])
end

def run2(i, laser_point)
  points = input_to_points i
  points -= [laser_point]
  final_order = [] of Point

  while points.size > 0
    laser_order = points
      .map { |p| PPair.new laser_point, p }
      .sort_by(&.dist)
      .uniq(&.slope)
      .sort_by(&.ang)
      .map(&.p2)
    final_order += laser_order
    points -= laser_order
  end

  final_order[199]
end

input = File.read_lines("input.txt")

puts run1 input
puts run2 input, Point.new(17, 22)
