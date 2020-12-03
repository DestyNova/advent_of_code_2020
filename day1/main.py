import itertools

with open("nums.txt") as f:
    content = f.readlines()

nums = [int(line) for line in content]

for i in itertools.combinations(nums, 3):
    if i[0]+i[1]+i[2] == 2020:
        print(i, i[0]*i[1]*i[2])
