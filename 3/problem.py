import math
from shapely.geometry import LineString, Point


def does_cross(l1, l2):
    line1 = LineString([l1[0], l1[1]])
    line2 = LineString([l2[0], l2[1]])
    return line1.intersection(line2)


def path_length(lines):
    length = 0
    for l in lines:
        line = LineString([l[0], l[1]])
        length += line.length
    return length


def gen_lines(i, pos=(0, 0)):
    c = []
    word = i[0]
    amount = int(i[1:])
    if word == "D":
        return (pos, (pos[0], pos[1] - amount))
    elif word == "U":
        return (pos, (pos[0], pos[1] + amount))
    elif word == "R":
        return (pos, (pos[0] + amount, pos[1]))
    elif word == "L":
        return (pos, (pos[0] - amount, pos[1]))


def get_coords(instructions):
    c = []
    prev = None
    for i in instructions:
        if len(c) == 0:
            v = gen_lines(i)
            c.append(v)
            prev = v
        else:
            v = gen_lines(i, prev[1])
            c.append(v)
            prev = v
    return c


def intersections(c1, c2):
    c = []
    for x in c1:
        for y in c2:
            v = does_cross(x, y)
            if v.coords != []:
                c.append((v.x, v.y))
    return c


def manhattan(points):
    mindist = float("inf")
    points = [p for p in points if p != (0, 0)]
    for point in points:
        dist = abs(point[0]) + abs(point[1])
        if dist < mindist:
            print(dist, point)

            mindist = dist
    return mindist


def length_until(chain, point):
    length = 0
    target_point = Point(point[0], point[1])
    for l in chain:
        line = LineString([l[0], l[1]])
        if line.contains(target_point):
            length += Point(l[0][0], l[0][1]).distance(target_point)
            break
        length += line.length
    return length


def all_together_p1(l1, l2):
    c1 = get_coords(l1.split(","))
    c2 = get_coords(l2.split(","))
    cross = intersections(c1, c2)
    return manhattan(cross)


def all_together_p2(l1, l2):
    c1 = get_coords(l1.split(","))
    c2 = get_coords(l2.split(","))
    crosses = intersections(c1, c2)
    min_length = float("inf")
    for cross in crosses:
        lu1 = length_until(c1, cross)
        lu2 = length_until(c2, cross)
        if lu1 + lu2 < min_length:
            min_length = lu1 + lu2
    return min_length


assert "D66"[1:] == "66"

with open("input.txt") as f:
    lines = f.read().splitlines()


def main():
    # print(all_together_p1(lines[0], lines[1]))
    print(all_together_p2(lines[0], lines[1]))
    print("nice")


main()
