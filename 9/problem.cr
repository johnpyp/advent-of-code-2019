require "file"

class IC
  @t : Hash(Int64, Int64)

  def initialize(tape : Array(Int64))
    @t = tape.map_with_index { |x, i| {i.to_i64, x} }.to_h
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
    outp = [] of Int64
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
      when  4 then @p += 2; outp << x
      when  5 then @p = x != 0 ? y : @p + 3
      when  6 then @p = x == 0 ? y : @p + 3
      when  7 then @t[zi] = x < y ? 1_i64 : 0_i64; @p += 4
      when  8 then @t[zi] = x == y ? 1_i64 : 0_i64; @p += 4
      when  9 then @rb += x; @p += 2
      when 99 then return outp
      else         raise "Unexpected path: #{op}, at pos #{@p}, cur #{cur}"
      end
    }
  end
end

input = File.read_lines("input.txt")
t = input[0].split(',').map &.to_i64
# part 1
ic = IC.new t
puts ic.run([1_i64])
# part 2
ic = IC.new t
puts ic.run([2_i64])
