require "file"
require "math"
require "time"
require "random"
require "../intcode"
require "../util"
require "big"

def repeat_arr(arr : Array(Int32), count)
  new_arr = [] of Int32
  arr.each { |elem|
    new_arr.concat([elem] * count)
  }
  new_arr
end

def padleft(arr, n, val)
  if n > arr.size
    to_pad = [val] * (n - arr.size)
    return to_pad + arr
  end
  arr
end

def run1(input, phases, dbg = false)
  pattern = [0, 1, 0, -1]
  num = BigInt.new input
  orig_len = num.digits.size
  phases.times {
    nex = ""
    digits = padleft(num.digits, orig_len, 0)
    puts "Input signal: #{digits[...10].join}" if dbg
    digits.size.times { |i|
      p = repeat_arr(pattern, i + 1)
      v = digits.map_with_index { |digit, j|
        pvalue = p[(j + 1) % p.size]
        # print "#{digit}*#{pvalue} + "
        digit * pvalue
      }.sum.abs % 10
      # print " = #{v}"
      # puts
      nex += v.to_s
    }
    num = BigInt.new nex
  }
  num
end

def run2(input, phases)
  input = input * 10000
  msg_offset = input[...7].to_i64
  digits = input[msg_offset..].chars.map(&.to_i).reverse
  puts "here"
  phases.times {
    sum = BigInt.new
    digits.each_with_index { |x, i|
      sum += x
      digits[i] = (sum.abs % 10).to_i
    }
  }
  digits.reverse[...8].join
end

input = File.read_lines("input.txt")
# puts run1("12345678", 4)
puts run2("03036732577212944063491565474664", 100)
# puts run1(input[0], 100)
puts run2(input[0], 100)
