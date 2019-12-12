require "file"
require "math"
require "time"

def cmp(x, y)
  case
  when x > y  then 1
  when x < y  then -1
  when x == y then 0
  else             raise "Unexpected path"
  end
end

class Moon
  property x, y, z, xv, yv, zv

  def initialize(x : Int32, y : Int32, z : Int32)
    @x = x
    @y = y
    @z = z
    @xv = 0
    @yv = 0
    @zv = 0
  end

  def energy
    potential = @x.abs + @y.abs + @z.abs
    kinetic = @xv.abs + @yv.abs + @zv.abs
    kinetic * potential
  end

  def compare(other : Moon)
    @xv += cmp(other.x, @x)
    @yv += cmp(other.y, @y)
    @zv += cmp(other.z, @z)
  end

  def update
    @x += @xv
    @y += @yv
    @z += @zv
  end

  def state
    {@x, @y, @z, @xv, @yv, @zv}
  end
end

def run(ms : Array(Moon), count : Int32)
  count.times { |_|
    ms.each { |m1|
      ms.each { |m2|
        m1.compare(m2)
      }
    }
    ms.each { |m| m.update }
  }
  ms.map(&.energy).sum
end

def run2(ms : Array(Moon))
  count = 0
  initial_x = ms.map(&.x)
  initial_y = ms.map(&.y)
  initial_z = ms.map(&.z)
  vals = [-1, -1, -1]
  loop {
    ms.each { |m1|
      ms.each { |m2|
        m1.compare(m2)
      }
    }
    ms.each(&.update)
    count += 1
    break if vals.all? { |x| x > 0 }
    vals[0] = count if ms.map(&.x) == initial_x && ms.all? { |m| m.xv == 0 } && vals[0] < 0
    vals[1] = count if ms.map(&.y) == initial_y && ms.all? { |m| m.yv == 0 } && vals[1] < 0
    vals[2] = count if ms.map(&.z) == initial_z && ms.all? { |m| m.zv == 0 } && vals[2] < 0
  }
  vals
end

# moons_test = [
#   Moon.new(-8, -10, 0),
#   Moon.new(5, 5, 10),
#   Moon.new(2, -7, 3),
#   Moon.new(9, -8, -3),
# ]

moons = [
  Moon.new(1, 4, 4),
  Moon.new(-4, -1, 19),
  Moon.new(-15, -14, 12),
  Moon.new(-17, 1, 10),
]

# puts run moons, 1000
# puts run2(moons_test).join(", ")
puts run2(moons).join(", ")
