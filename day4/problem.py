def check(i):
    s = str(i)
    has_adj = False
    prev_c = None
    for c in s:
        if c == prev_c:
            has_adj = True
            break
        prev_c = c
    if not has_adj:
        return False

    prev_c = None
    combo = 1
    count_list = []
    for c in s:
        if c == prev_c:
            combo += 1
        elif combo > 1:
            count_list.append(combo)
            combo = 1
        else:
            combo = 1
        prev_c = c
    if combo > 1:
        count_list.append(combo)
    if not 2 in count_list:
        return False
    escalates = True
    prev_c = 0
    for c in s:
        if not int(c) >= prev_c:
            escalates = False
            break
        prev_c = int(c)
    if not escalates:
        return False
    return True


with open("input.txt") as f:
    lines = f.read().splitlines()

r = lines[0].split("-")
start = int(r[0])
end = int(r[1])

count = 0

assert check(5677999) == True
for i in range(start, end):
    if check(i):
        count += 1
print(count)
