import heapq

def astar(start):
    q = [(start.weight, start.name, start)]    # priority queue
    while len(q) > 0:
        weight, name, node = heapq.heappop(q)
        #print(node)
        if isGoal(node):
            yield node
        for x in node.children:
            heapq.heappush(q, (x.weight, x.name, x))

class Node:
    def __init__(self, name, weight=0):
        self.name = name
        self.children = []
        self.weight = weight
    def __le__(self, other):
        return other.name < self.name
def isGoal(node):
    return node.name == "Goal"


n = Node("start")
b = Node("child1", 1)
c = Node("child2", 2)
e = Node("child3", 2)
d = Node("Goal", 0)

n.children = [b,c, e]
b.children = [d]
c.children = [d]
e.children = [d]

solutions = []
i = 0
for sol in astar(n):
    solutions.append(sol)
    if i == 3:
        break
    i += 1

