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

def run1(i)
  points = [] of Point
  i.each_with_index { |row, r|
    row.chars.each_with_index { |char, c|
      if char == '#'
        points << Point.new c, r
      end
    }
  }

  can_see = points.map { |point|
    {points.map { |point2|
      s = point.slope(point2)
      if point2.x < point.x
        s + 0.000001
      else
        s
      end
    }.uniq.size - 1, point}
  }

  puts can_see.max_by { |p| p[0] }
end

def run2(i, laser_point)
  points = [] of Point
  i.each_with_index { |row, r|
    row.chars.each_with_index { |char, c|
      if char == '#'
        points << Point.new c, r
      end
    }
  }
  points -= [laser_point]
  dest = [] of Point

  while points.size > 0
    by_dist = points.sort_by { |point|
      laser_point.dist(point)
    }
    visible = by_dist.uniq { |p|
      s = laser_point.slope(p)
      laser_point.x < p.x ? s + 0.00001 : s
    }
    laser_order = visible.sort_by { |point|
      laser_point.ang(point)
    }
    dest += laser_order
    points -= laser_order
  end

  puts dest[199]
end

input = File.read_lines("input.txt")

run1 input
run2 input, Point.new(17, 22)
