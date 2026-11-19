
# Task 1: Binary Search Tree
print("----- Task 1 -----")
print()
class Node:
    def __init__(self, code):
        self.code = code
        self.left = None
        self.right = None


def insert(root, code):
    if root is None:
        return Node(code)

    if code < root.code:
        root.left = insert(root.left, code)
    elif code > root.code:
        root.right = insert(root.right, code)

    return root


def search(root, code):
    if root is None:
        return False

    if root.code == code:
        return True
    elif code < root.code:
        return search(root.left, code)
    else:
        return search(root.right, code)


def height(root):
    if root is None:
        return 0

    return 1 + max(height(root.left), height(root.right))

hubs = [50, 30, 70, 20, 40, 60, 80]

root = None

for code in hubs:
    root = insert(root, code)

search_code = 60

if search(root, search_code):
    print(search_code, "Hub found")
else:
    print(search_code, "Hub not found")

# Tree height
print("BST Height:", height(root))

sorted_hubs = [10, 20, 30, 40, 50]
sorted_root = None

for code in sorted_hubs:
    sorted_root = insert(sorted_root, code)

print("Height with sorted input:", height(sorted_root))
print()


# Task 2: Hash Map - Parcel Tracking
print("----- Task 2 -----")
parcels = {
    "TR101": "HUB01",
    "TR102": "HUB02",
    "TR103": "HUB01",
    "TR104": "HUB03"
}
scans = [
    ("TR101", "HUB01"),
    ("TR102", "HUB02"),
    ("TR103", "HUB01"),
    ("TR101", "HUB01"),
    ("TR104", "HUB03"),
    ("TR102", "HUB02"),
    ("TR101", "HUB02")
]
scanned = set()

print("Duplicate Scans:")

for tracking, hub in scans:
    key = (tracking, hub)

    if key in scanned:
        print(tracking, "scanned twice at", hub)
    else:
        scanned.add(key)

print("\nParcel Tracking Details:")

for tracking, hub in parcels.items():
    print(tracking, "->", hub)
print()


# Task 3: Graph - BFS and DFS
print("----- Task 3 -----")
from collections import deque
graph = {
    "HUB01": ["HUB02", "HUB03"],
    "HUB02": ["HUB01", "HUB04", "HUB05"],
    "HUB03": ["HUB01", "HUB06"],
    "HUB04": ["HUB02", "HUB07"],
    "HUB05": ["HUB02", "HUB08"],
    "HUB06": ["HUB03", "HUB09"],
    "HUB07": ["HUB04", "HUB10"],
    "HUB08": ["HUB05"],
    "HUB09": ["HUB06"],
    "HUB10": ["HUB07"]
}
def bfs(graph, start, destination):
    queue = deque([(start, [start])])
    visited = {start}

    while queue:
        current, path = queue.popleft()

        if current == destination:
            return path

        for neighbour in graph[current]:
            if neighbour not in visited:
                visited.add(neighbour)
                queue.append((neighbour, path + [neighbour]))

    return None

def dfs(graph, start, visited=None):
    if visited is None:
        visited = set()

    visited.add(start)

    for neighbour in graph[start]:
        if neighbour not in visited:
            dfs(graph, neighbour, visited)

    return visited

start = "HUB01"
destination = "HUB08"

route = bfs(graph, start, destination)

if route:
    print("Shortest Route:", " -> ".join(route))
    print("Number of Hops:", len(route) - 1)
else:
    print("No route available")

print("\nReachable Hubs from Central Depot:")

reachable = dfs(graph, "HUB01")

for hub in sorted(reachable):
    print(hub)
print()


# Task 4: Sliding Window - Highest 4-Hour Average
print("----- Task 4 -----")
parcels = [20, 35, 40, 25, 60, 70, 55, 45, 30, 50]

window_size = 4
window_sum = sum(parcels[:window_size])
max_sum = window_sum
max_index = 0
for i in range(window_size, len(parcels)):
    window_sum += parcels[i] - parcels[i - window_size]

    if window_sum > max_sum:
        max_sum = window_sum
        max_index = i - window_size + 1
max_average = max_sum / window_size

print("Hourly Parcel Counts:", parcels)
print("Highest 4-Hour Window:", parcels[max_index:max_index + window_size])
print("Starting Hour:", max_index + 1)
print("Ending Hour:", max_index + window_size)
print("Maximum Parcel Count:", max_sum)
print("Highest Average:", max_average)
print()


# Task 5: Two Pointers - Palindrome Check
print("----- Task 5 -----")
def is_palindrome(route):
    # Remove separators and convert to lowercase
    cleaned = ""

    for char in route:
        if char.isalnum():
            cleaned += char.lower()

    left = 0
    right = len(cleaned) - 1

    while left < right:
        if cleaned[left] != cleaned[right]:
            return False

        left += 1
        right -= 1

    return True

route1 = "HUB01-HUB02-HUB01"
route2 = "HUB01-HUB02-HUB03"
print("Route 1:", route1)
print("Palindrome:", is_palindrome(route1))
print("\nRoute 2:", route2)
print("Palindrome:", is_palindrome(route2))



