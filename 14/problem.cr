require "file"
require "math"
require "time"
require "random"
require "../intcode"
require "../util"

alias Pair = Tuple(Int32, String)
alias Nodes = Hash(String, Tuple(Int32, Array(Pair)))

class Recipes
  property store
  @nodes : Nodes

  def initialize(nodes : Array(String))
    @store = Hash(String, Float64).new(0)
    @nodes = Recipes.parse(nodes)
  end

  def get_ore(target = "FUEL", req = 1)
    if target == "ORE"
      @store["ORE"] += req
      return req
    end

    output, inputs = @nodes[target]
    reuse = [req, @store[target]].min
    req -= reuse
    @store[target] -= reuse

    n = (req / output).ceil.to_i64

    ore = 0_i64
    inputs.each { |(amt, name)|
      ore += get_ore(name, n * amt)
    }

    puts store[target] if target == "ORE"
    @store[target] += n * output - req
    ore
  end

  def self.parse(lines)
    lines.each_with_object(Nodes.new) { |line, obj|
      input, output = line.split(" => ")
      outq, outn = output.split
      inp = input.split(',').map(&.split).map { |(amt, name)| {amt.to_i, name} }

      obj[outn] = {outq.to_i, inp}
    }
  end
end

def part2(lines, target)
  lower = 0_i64
  upper = target
  while lower + 1 < upper
    mid = (lower + upper) // 2
    recipes = Recipes.new(lines)
    ore = recipes.get_ore(req: mid)
    case
    when ore > target then upper = mid
    when ore < target then lower = mid
    end
  end
  lower
end

lines = File.read_lines("input.txt")

target = 1_000_000_000_000_i64
# graph = Recipes.new(lines)
# p! graph.get_ore
# p! part2(lines, target)
# Part 1
p! Recipes.new(lines).get_ore
# Part 2
p! part2(lines, target)
