#!/bin/crystal
require "file"
require "spec"

def intcode(tape, i = [0, 0], pos = 0)
  t = tape.clone
  i = i.clone
  p = pos.clone
  outp = [] of Int32
  loop {
    cur = t[p]
    op = cur % 100
    x = (cur // 100) % 10 == 0 ? t[p + 1] : p + 1 rescue 0
    y = (cur // 1000) % 10 == 0 ? t[p + 2] : p + 2 rescue 0
    z = (cur // 10000) % 10 == 0 ? t[p + 3] : p + 3 rescue 0

    case op
    when  1 then t[z] = t[x] + t[y]; p += 4
    when  2 then t[z] = t[x] * t[y]; p += 4
    when  3 then t[x] = i.pop rescue break; p += 2
    when  4 then outp.push(t[x]); p += 2
    when  5 then t[x] != 0 ? (p = t[y]) : (p += 3)
    when  6 then t[x] == 0 ? (p = t[y]) : (p += 3)
    when  7 then t[t[p + 3]] = t[x] < t[y] ? 1 : 0; p += 4
    when  8 then t[t[p + 3]] = t[x] == t[y] ? 1 : 0; p += 4
    when 99 then return outp, t, p, true
    else         raise "Unexpected path: #{op}, at pos #{p}, cur #{cur}"
    end
  }
  return outp, t, p, false
end

def run(tape)
  t = tape.split(',').map &.to_i
  max_amp = 0
  (0..4).to_a.permutations.each { |perm|
    prev = 0
    perm.each { |setting|
      input = [prev, setting]
      outp, _, _, _ = intcode(t, input)
      prev = outp[0]
    }
    if prev > max_amp
      max_amp = prev
    end
  }
  max_amp
end

def run2(tape)
  t = tape.split(',').map &.to_i
  max_amp = 0
  (5..9).to_a.permutations.each { |perm|
    map = {} of Int32 => Tuple(Int32, Array(Int32))
    prev = 0
    count = 0
    loop {
      setting = perm[count % perm.size]
      pos, tcache = map[setting]? || {0, t}
      input = pos == 0 ? [prev, setting] : [prev]
      outp, tnew, p, stop = intcode(tcache, input, pos)
      prev = outp[0]? || prev
      map[setting] = {p, tnew}
      if stop
        break
      end
      count += 1
    }
    if prev > max_amp
      max_amp = prev
    end
  }
  max_amp
end

input = File.read_lines("input.txt")

tape = input[0]
puts run tape
puts run2 tape

describe "tests" do
end
