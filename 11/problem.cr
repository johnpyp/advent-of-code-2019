require "file"
require "math"
require "../intcode/intcode.cr"
record Point, x : Int32 = 0, y : Int32 = 0 do
  def +(other)
    Point.new x + other.x, y + other.y
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
