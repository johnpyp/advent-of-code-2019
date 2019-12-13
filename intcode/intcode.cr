class IC
  property t
  @t : Hash(Int64, Int64)

  def initialize(tape : (Array(Int32) | Array(Int64) | String))
    @t = case tape
         when Array(Int64) then tape.map_with_index { |x, i| {i.to_i64, x} }.to_h
         when Array(Int32) then tape.map_with_index { |x, i| {i.to_i64, x.to_i64} }.to_h
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

  def run(input : (Array(Int64) | Int64 | Int32 | Array(Int32) | Nil) = [] of Int64)
    i = case input
        when Array(Int64) then input
        when Array(Int32) then input.map(&.to_i64)
        when Int64        then [input]
        when Int32        then [input.to_i64]
        when nil          then [] of Int64
        else                   raise "Unexpected input"
        end
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

  def self.run(t, input = nil)
    ic = IC.new t
    ic.run input
  end
end
