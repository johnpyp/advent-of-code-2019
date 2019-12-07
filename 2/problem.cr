require "file"

def run(tape)
  t = tape.clone
  p = 0
  loop {
    cur = t[p]
    op = cur % 100
    x = t[p + 1] rescue 0
    y = t[p + 2] rescue 0
    z = t[p + 3] rescue 0
    case op
    when  1 then t[z] = t[x] + t[y]; p += 4
    when  2 then t[z] = t[x] * t[y]; p += 4
    when 99 then break t
    else         raise "Unexpected path: #{op}, at pos #{p}, cur #{cur}"
    end
  }
end

input = File.read_lines("input.txt")
base_tape = input[0].split(',').map &.to_i

# part 1
tape = base_tape.clone
tape[1..2] = [12, 2]
puts run(tape)[0]

# part 2
correct = 19690720
puts 100.times.to_a.permutations(2).find { |x|
  t = base_tape.clone
  t[1..2] = x
  run(t)[0] == correct
}
