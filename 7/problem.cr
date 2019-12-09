require "file"

class IC
  def initialize(tape : Array(Int32))
    @t = tape
    @p = 0
  end

  def run(input)
    i = input
    loop {
      cur = @t[@p]
      op = cur % 100
      x = (cur // 100) % 10 == 0 ? @t[@p + 1] : @p + 1 rescue 0
      y = (cur // 1000) % 10 == 0 ? @t[@p + 2] : @p + 2 rescue 0
      z = (cur // 10000) % 10 == 0 ? @t[@p + 3] : @p + 3 rescue 0

      case op
      when  1 then @t[z] = @t[x] + @t[y]; @p += 4
      when  2 then @t[z] = @t[x] * @t[y]; @p += 4
      when  3 then @t[x] = i.pop; @p += 2
      when  4 then @p += 2; return @t[x]
      when  5 then @t[x] != 0 ? (@p = @t[y]) : (@p += 3)
      when  6 then @t[x] == 0 ? (@p = @t[y]) : (@p += 3)
      when  7 then @t[z] = @t[x] < @t[y] ? 1 : 0; @p += 4
      when  8 then @t[z] = @t[x] == @t[y] ? 1 : 0; @p += 4
      when 99 then return nil
      else         raise "Unexpected path: #{op}, at pos #{p}, cur #{cur}"
      end
    }
  end
end

input = File.read_lines("input.txt")

tape = input[0]
t = tape.split(',').map &.to_i

# part 1
puts (0..4).to_a.permutations.max_of { |perm|
  prev = 0
  perm.each { |setting|
    input = [prev, setting]
    ic = IC.new t
    prev = ic.run(input) || break
  }
  prev
}

# part 2
puts (5..9).to_a.permutations.max_of { |perm|
  map = {} of Int32 => IC
  prev = 0
  loop {
    res = prev
    perm.each { |setting|
      input = map.has_key?(setting) ? [prev] : [prev, setting]
      map[setting] ||= IC.new t
      prev = map[setting].run input
      break if !prev
    }
    break res if !prev
  }
}
