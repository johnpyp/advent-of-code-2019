def parse_command(command):
    word = command[0]
    amount = int(command[1:])
    return {"word": word, "amount": amount}


def get_delta(word):
    if word == "D":
        return {"x": 0, "y": -1}
    if word == "U":
        return {"x": 0, "y": 1}
    if word == "R":
        return {"x": 1, "y": 0}
    if word == "L":
        return {"x": -1, "y": 0}


def parse_line(line):
    commands = line.split(",")
    all_points = []
    points_map = {}
    pos = {"x": 0, "y": 0}
    steps = 0
    for command in commands:
        c = parse_command(command)
        delta = get_delta(c["word"])
        for i in range(c["amount"]):
            pos["x"] += delta["x"]
            pos["y"] += delta["y"]
            all_points.append(pos.copy())
            steps += 1
            px = pos["x"]
            py = pos["y"]
            points_map[px] = points_map.get(px) or {}
            points_map[px][py] = points_map[px].get(py) or steps
    return {"all_points": all_points, "points_map": points_map}


def man_distance(point):
    return abs(point["x"]) + abs(point["y"])


with open("input.txt") as f:
    lines = f.read().splitlines()

line1 = parse_line(lines[0])
line2 = parse_line(lines[1])
pm = line2["points_map"]

intersect_points = []
for point in line1["all_points"]:
    px = point["x"]
    py = point["y"]
    if point != {"x": 0, "y": 0} and px in pm and py in pm[px]:
        intersect_points.append(point)

# part 1
distances = [man_distance(x) for x in intersect_points]
min_dist = float("inf")
for distance in distances:
    if distance < min_dist:
        min_dist = distance
print(min_dist)

# part 2
min_steps = float("inf")
for point in intersect_points:
    px = point["x"]
    py = point["y"]
    steps = line1["points_map"][px][py] + pm[px][py]
    if steps < min_steps:
        min_steps = steps
print(min_steps)


