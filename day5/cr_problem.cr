#!/bin/crystal run
require "file"
require "spec"

def handle_mode(tape, mode, v)
  case mode
  when 0 then tape[v]
  when 1 then v
  else        raise "Bad mode"
  end
end

def get_mode(op_string, num)
  (op_string[num + 1]? || "0").to_i
end

def op_code_handler(c, p, i = 0)
  mc = c.clone
  full_op = c[p].to_s.reverse
  op = full_op[0...2].reverse.to_i
  np = p
  case op
  when 99 then return c
  when 1
    m1 = get_mode(full_op, 1)
    m2 = get_mode(full_op, 2)
    p1 = c[p + 1]
    p2 = c[p + 2]
    p3 = c[p + 3]
    mc[p3] = handle_mode(c, m1, p1) + handle_mode(c, m2, p2)
    np += 4
  when 2
    m1 = get_mode(full_op, 1)
    m2 = get_mode(full_op, 2)
    p1 = c[p + 1]
    p2 = c[p + 2]
    p3 = c[p + 3]
    mc[p3] = handle_mode(c, m1, p1) * handle_mode(c, m2, p2)
    np += 4
  when 3
    p1 = c[p + 1]
    mc[p1] = i
    np += 2
  when 4
    m1 = get_mode(full_op, 1)
    p1 = c[p + 1]
    puts "4: #{handle_mode(c, m1, p1)}"
    np += 2
  when 5
    m1 = get_mode(full_op, 1)
    m2 = get_mode(full_op, 2)
    p1 = c[p + 1]
    p2 = c[p + 2]
    if handle_mode(c, m1, p1) != 0
      np = handle_mode(c, m2, p2)
    else
      np += 3
    end
  when 6
    m1 = get_mode(full_op, 1)
    m2 = get_mode(full_op, 2)
    p1 = c[p + 1]
    p2 = c[p + 2]
    if handle_mode(c, m1, p1) == 0
      np = handle_mode(c, m2, p2)
    else
      np += 3
    end
  when 7
    m1 = get_mode(full_op, 1)
    m2 = get_mode(full_op, 2)
    m3 = get_mode(full_op, 3)
    p1 = c[p + 1]
    p2 = c[p + 2]
    p3 = c[p + 3]
    if handle_mode(c, m1, p1) < handle_mode(c, m2, p2)
      mc[p3] = 1
    else
      mc[p3] = 0
    end
    np += 4
  when 8
    m1 = get_mode(full_op, 1)
    m2 = get_mode(full_op, 2)
    m3 = get_mode(full_op, 3)
    p1 = c[p + 1]
    p2 = c[p + 2]
    p3 = c[p + 3]
    if handle_mode(c, m1, p1) == handle_mode(c, m2, p2)
      mc[p3] = 1
    else
      mc[p3] = 0
    end
    np += 4
  else
    raise "Unexpected path: #{op}, at pos #{p}, initial op #{c[p]}, full_op #{full_op}"
  end
  op_code_handler(mc, np)
end

def parse_line(line)
  tape = line.split(',').map &.to_i
  # op_code_handler(tape, 0, 1)
  op_code_handler(tape, 0, 5)
end

input = File.read_lines("input.txt")

parse_line(input[0])

describe "handle_mode" do
  it "works" do
    handle_mode([1, 2, 3, 4], 0, 3).should eq 4
  end
end

# puts op_code_handler([3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8], 0, 7)
