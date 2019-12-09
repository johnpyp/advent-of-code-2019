require "file"

def escalates(str)
  prev = 0
  str.each_char.all? { |c|
    c = c.to_i
    good = prev <= c
    prev = c
    good
  }
end

s, e = File.read("input.txt").strip.split('-').map &.to_i
tallied = (s..e)
  .map(&.to_s)
  .select { |str| escalates(str) }
  .map { |str| str.chars.tally.values.reject(1) }

# part 1
puts tallied.count { |a| a.size > 0 }
# part 2
puts tallied.count { |a| a.includes? 2 }
