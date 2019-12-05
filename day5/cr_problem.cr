#!/bin/crystal run
require "file"
require "spec"

def run(tape, i = 0)
  t = tape.clone
  p = 0
  out = [] of Int32
  loop {
    cur = tape[p]
    op = cur % 100
    x = (cur // 100) % 10 == 0 ? t[t[p + 1]] : t[p + 1] rescue 0
    y = (cur // 1000) % 10 == 0 ? t[t[p + 2]] : t[p + 2] rescue 0
    z = (cur // 10000) % 10 == 0 ? t[t[p + 3]] : t[p + 3] rescue 0
    pp x, y, z
    case op
    when 99 then break
    when  1 then t[z] = x + y; p += 4
    when  2 then t[z] = x * y; p += 4
    when  3 then t[x] = i; p += 2
    when  4 then out.push(x); p += 2
    when  5 then x != 0 ? (p = y) : (p += 3)
    when  6 then x == 0 ? (p = y) : (p += 3)
    when  7 then t[z] = x < y ? 1 : 0; p += 4
    when  8 then t[z] = x == y ? 1 : 0; p += 4
    else         raise "Unexpected path: #{op}, at pos #{p}, cur #{cur}"
    end
  }
  out
end

input = File.read_lines("input.txt")

tape = input[0].split(',').map &.to_i
puts run tape, 1
puts run tape, 5
