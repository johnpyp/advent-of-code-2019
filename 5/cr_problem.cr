#!/bin/crystal run
require "file"
require "spec"

def run(tape, i = 0)
  t = tape.clone
  p = 0
  out = [] of Int32
  loop {
    cur = t[p]
    op = cur % 100
    x = (cur // 100) % 10 == 0 ? t[p + 1] : p + 1 rescue 0
    y = (cur // 1000) % 10 == 0 ? t[p + 2] : p + 2 rescue 0
    z = (cur // 10000) % 10 == 0 ? t[p + 3] : p + 3 rescue 0
    case op
    when  1 then t[z] = t[x] + t[y]; p += 4
    when  2 then t[z] = t[x] * t[y]; p += 4
    when  3 then t[x] = i; p += 2
    when  4 then out.push(t[x]); p += 2
    when  5 then t[x] != 0 ? (p = t[y]) : (p += 3)
    when  6 then t[x] == 0 ? (p = t[y]) : (p += 3)
    when  7 then t[t[p + 3]] = t[x] < t[y] ? 1 : 0; p += 4
    when  8 then t[t[p + 3]] = t[x] == t[y] ? 1 : 0; p += 4
    when 99 then break
    else         raise "Unexpected path: #{op}, at pos #{p}, cur #{cur}"
    end
  }
  out
end

input = File.read_lines("input.txt")

tape = input[0].split(',').map &.to_i
puts run tape, 1
puts run tape, 5
