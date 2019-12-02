import math


def module_fuel(mass):
    return math.floor(mass / 3) - 2


assert module_fuel(1969) == 654
assert module_fuel(12) == 2
assert module_fuel(100756) == 33583

lines = None
with open("input.txt") as f:
    lines = f.read().splitlines()

total = 0
for line in lines:
    temp_total = 0
    prev_val = line
    while True:
        val = module_fuel(int(prev_val))
        if val <= 0:
            break
        else:
            temp_total += val
            prev_val = val
    total += temp_total


print(total)
