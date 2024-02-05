# quick sort
q = lambda l: q ([x for x in l[1:] if x <= l[0]]) + [l[0]] + q([x for x in l if x > l[0]]) if l else []

# break down 
# q = lambda 1: 
# q([x for x in l[1:] if x < l[0]]) + \
# [l[0]] + \
# q([x for x in l if x > 1[0]]) if l else []


# Breadth First Search
map = {}

map["adrian" ] = ["barry", "chelsea", "dana"]
map["barry"  ] = ["adrian", "ethan"]
map["chelsea"] = ["adrian", "heather"]
map["dana"   ] = ["adrian", "fiona"]
map["ethan"  ] = ["barry", "ian"]
map["ian"    ] = ["ethan", "gladys"]
map["fiona"  ] = ["dana", "gladys"]
map["gladys" ] = ["ian", "fiona"]
map["heather"] = ["chelsea"]

def BFS(paths, target, graph):
    if paths == []:
        return paths
    else:
        for path in paths:
            if path[-1] == target:
                return("the answer is: ", path)
        newPaths = []
        for path in paths:
            frontier = path[-1]
            for neighbor in map[frontier]:
                if neighbor not in path:
                    newPaths.append(path + [neighbor])
        print("Moving ahead: ", newPaths)
        return BFS(newPaths, target, map)
# test
a = BFS([["adrian"]], "ian", map)
print(a)

# Permuations of words

letter = 'a'
words = ['bc','cb']

def fun(letter, words):
    result = []
    for word in words:
        line = []
        for index in range(len(word)+1):
            line += [ word[0:index] + letter + word[index:] ]
        result += line
    return result

def perm(word):
    if len(word) <= 1:
        return [word]
    else:
        return fun(word[0], perm(word[1:]))


def perm(word,step=0):
    if step == 0:
        print("".join(word))
    for i in range(step,len(word)):
        word_Copy = [x for x in word]
        word_Copy[i],word_Copy[step] = word_Copy[step],word_Copy[i]
        perm(wordCopy, step + 1)

def bfs()