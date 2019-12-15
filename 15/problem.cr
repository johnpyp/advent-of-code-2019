require "file"
require "math"
require "time"
require "random"
require "../intcode"
require "../util"

record Pos, x : Int32 = 0, y : Int32 = 0 {
  def man_distance
    x.abs + y.abs
  end

  def +(other)
    Pos.new x + other.x, y + other.y
  end

  def -(other)
    Pos.new x - other.x, y - other.y
  end
}

# north (1), south (2), west (3), and east (4).
class Graph
  property ic

  def initialize(i)
    @ic = IC.new i, false
    @pos = Pos.new
  end

  def surrounding(pos)
    [
      pos + Pos.new(0, 1),
      pos + Pos.new(0, -1),
      pos + Pos.new(-1, 0),
      pos + Pos.new(1, 0),
    ]
  end

  def direction(pos, new_pos)
    case new_pos - pos
    when Pos.new(0, 1)  then 1
    when Pos.new(0, -1) then 2
    when Pos.new(-1, 0) then 3
    when Pos.new(1, 0)  then 4
    else                     raise "Unexpected diff"
    end
  end

  def inverse(direc)
    case direc
    when 1 then 2
    when 2 then 1
    when 3 then 4
    when 4 then 3
    else        raise "Unexpected direction"
    end
  end

  def run
    visited = Set(Pos).new
    queue = Deque.new([{Pos.new(0, 0), 0, @ic.t.clone}])
    loop {
      pos, dist, t = queue.shift
      visited.add(pos)
      children = surrounding(pos) - visited.to_a
      # puts "Visiting #{pos}, dist #{dist}, children #{children.size}"
      @ic.t = t
      children.each_with_index { |child, i|
        direc = direction(pos, child)
        @ic.send(direc)
        res = @ic.run || raise "Unexpected halt"
        case res
        when 0
          # puts "Child #{i}, #{child}, #{direc}, is a wall"
        when 1
          # puts "Child #{i}, #{child}, #{direc}, good - adding to queue"
          queue.push({child, dist + 1, @ic.t.clone})
          @ic.send(inverse(direc))
          back = @ic.run || raise "Unexpected halt"
          raise "Unexpected error #{back}" if back != 1
        when 2
          return dist + 1, @ic.t.clone, child
        end
      }
    }
  end

  def run2(pos)
    visited = Set(Pos).new
    dist_set = Set(Int32).new
    queue = Deque.new([{pos, 0, @ic.t.clone}])
    while !queue.empty?
      pos, dist, t = queue.shift
      dist_set.add(dist)
      visited.add(pos)
      children = surrounding(pos) - visited.to_a
      puts "Visiting #{pos}, dist #{dist}, children #{children.size}"
      @ic.t = t
      children.each_with_index { |child, i|
        direc = direction(pos, child)
        @ic.send(direc)
        res = @ic.run || raise "Unexpected halt"
        case res
        when 0
          puts "Child #{i}, #{child}, #{direc}, is a wall"
        when 1, 2
          puts "Child #{i}, #{child}, #{direc}, good - adding to queue"
          queue.push({child, dist + 1, @ic.t.clone})
          @ic.send(inverse(direc))
          back = @ic.run || raise "Unexpected halt"
          raise "Unexpected error #{back}" if back != 1 && back != 2
        end
      }
    end
    dist_set.max
  end
end

input = File.read("input.txt")

graph = Graph.new input.strip
dist, _, pos = graph.run
p! dist
max = graph.run2(pos)
p! max
# graph = Graph.new input.strip
# graph.ic.t = t
