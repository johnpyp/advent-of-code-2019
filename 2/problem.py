import math


def intcode_parser(intcodes, pos=0):
    mutcodes = intcodes.copy()
    ic = intcodes[pos]
    if ic == 99:
        return intcodes
    elif ic == 1:
        p1 = intcodes[pos + 1]
        p2 = intcodes[pos + 2]
        p3 = intcodes[pos + 3]
        mutcodes[p3] = intcodes[p1] + intcodes[p2]
    elif ic == 2:
        p1 = intcodes[pos + 1]
        p2 = intcodes[pos + 2]
        p3 = intcodes[pos + 3]
        mutcodes[p3] = intcodes[p1] * intcodes[p2]
    return intcode_parser(mutcodes, pos + 4)


with open("input.txt") as f:
    lines = f.read().splitlines()

l = lines[0]


def main():
    for i in range(0, 100):
        for j in range(0, 100):
            base = [int(x) for x in l.split(",")]
            base[1] = i
            base[2] = j
            v = intcode_parser(base)
            print(v)
            if v[0] == 19690720:
                print("Found")
                return


main()
