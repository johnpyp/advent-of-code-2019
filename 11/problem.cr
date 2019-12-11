require "file"
require "math"
record Point, x : Int32 = 0, y : Int32 = 0 do
  def +(other)
    Point.new x + other.x, y + other.y
  end
end

class IC
  @t : Hash(Int64, Int64)

  def initialize(tape : (Array(Int64) | String))
    @t = case tape
         when Array(Int64) then tape.map_with_index { |x, i| {i.to_i64, x} }.to_h
         when String       then tape.split(',').map_with_index { |x, i| {i.to_i64, x.to_i64} }.to_h
         else                   raise "Bad tape input"
         end
    @p = 0_i64
    @rb = 0_i64
  end

  def get(idx : Int64)
    @t[idx]? || 0_i64
  end

  def mode(mode, n)
    case mode
    when 0 then get(@p + n)
    when 1 then @p + n
    when 2 then @rb + get(@p + n)
    else        raise "Unexpected mode #{mode}"
    end
  end

  def run(input : Array(Int64))
    i = input
    loop {
      cur = @t[@p]
      op = cur % 100
      xi = mode(cur // 100 % 10, 1)
      yi = mode(cur // 1000 % 10, 2)
      zi = mode(cur // 10000 % 10, 3)
      x, y, z = get(xi), get(yi), get(zi)

      case op
      when  1 then @t[zi] = x + y; @p += 4
      when  2 then @t[zi] = x * y; @p += 4
      when  3 then @t[xi] = i.pop; @p += 2
      when  4 then @p += 2; return x
      when  5 then @p = x != 0 ? y : @p + 3
      when  6 then @p = x == 0 ? y : @p + 3
      when  7 then @t[zi] = x < y ? 1_i64 : 0_i64; @p += 4
      when  8 then @t[zi] = x == y ? 1_i64 : 0_i64; @p += 4
      when  9 then @rb += x; @p += 2
      when 99 then return nil
      else         raise "Unexpected path: #{op}, at pos #{@p}, cur #{cur}"
      end
    }
  end

  def self.run(t, input : Array(Int64))
    ic = IC.new t
    ic.run input
  end
end

class Robot
  def initialize(ic : IC, spanel : Int64)
    @ic = ic
    @grid = {Point.new => spanel}
    @p = Point.new
    # 0 -> Up
    # 1 -> Right
    # 2 -> Down
    # 3 -> Left
    @direc = 0
  end

  def move
    @p += case @direc
          when 0 then Point.new 0, 1
          when 1 then Point.new 1, 0
          when 2 then Point.new 0, -1
          when 3 then Point.new -1, 0
          else        raise "Unexpected direction #{@direc}"
          end
  end

  def get(p : Point)
    @grid[p]? || 0_i64
  end

  def run
    loop {
      @grid[@p] = @ic.run([get(@p)]) || break
      o2 = @ic.run [] of Int64 || break
      case o2
      when 0 then @direc = (@direc - 1) % 4
      when 1 then @direc = (@direc + 1) % 4
      else        raise "Unexpected angle change #{o2}"
      end
      move
    }
    @grid
  end
end

input = File.read_lines("input.txt")
# part 1
ic = IC.new input[0]
robot = Robot.new ic, 0_i64
puts robot.run.size
# part 2
ic = IC.new input[0]
robot = Robot.new ic, 1_i64
hm = robot.run
arr_2d = 20.times.to_a.map { |_| 50.times.to_a.map { |_| 0 } }
white_points = hm.select { |_, v| v == 1 }.keys
white_points.each { |point|
  arr_2d[-(point.y + 10)][point.x] = 1
}
arr_2d.each { |row| puts row.join("").gsub("0", " ") }
