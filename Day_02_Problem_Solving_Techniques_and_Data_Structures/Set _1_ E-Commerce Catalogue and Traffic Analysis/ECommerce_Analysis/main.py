# Task 1 – Binary Search Tree

print("---------TASK-1-----")
class Node:
    def __init__(self, value):
        self.value = value
        self.left = None
        self.right = None


class BST:
    def __init__(self):
        self.root = None

    def insert(self, root, value):
        if root is None:
            return Node(value)

        if value < root.value:
            root.left = self.insert(root.left, value)
        elif value > root.value:
            root.right = self.insert(root.right, value)

        return root

    def search(self, root, value):
        if root is None or root.value == value:
            return root

        if value < root.value:
            return self.search(root.left, value)

        return self.search(root.right, value)

    def inorder(self, root):
        if root:
            self.inorder(root.left)
            print(root.value, end=" ")
            self.inorder(root.right)

    def preorder(self, root):
        if root:
            print(root.value, end=" ")
            self.preorder(root.left)
            self.preorder(root.right)

    def postorder(self, root):
        if root:
            self.postorder(root.left)
            self.postorder(root.right)
            print(root.value, end=" ")


# Main Program
categories = [
    "Electronics", "Clothing", "Books", "Furniture",
    "Sports", "Beauty", "Toys", "Groceries",
    "Footwear", "Jewellery", "Automotive", "Kitchen",
    "Stationery", "Accessories", "Appliances"
]

tree = BST()

for category in categories:
    tree.root = tree.insert(tree.root, category)

print("Inorder Traversal:")
tree.inorder(tree.root)

print("\nPreorder Traversal:")
tree.preorder(tree.root)

print("\nPostorder Traversal:")
tree.postorder(tree.root)

target = input("\n\nEnter category to search: ")

result = tree.search(tree.root, target)

if result:
    print("Category found:", result.value)
else:
    print("Category not found")

#TASK - 2

print("------TASK - 2------")
import time
class HashTable:
    def __init__(self, size):
        self.size = size
        self.table = [[] for _ in range(size)]

    def hash_function(self, key):
        return sum(ord(ch) for ch in key) % self.size

    def insert(self, key, value):
        index = self.hash_function(key)

        for item in self.table[index]:
            if item[0] == key:
                item[1] = value
                return

        self.table[index].append([key, value])

    def search(self, key):
        index = self.hash_function(key)

        for item in self.table[index]:
            if item[0] == key:
                return item[1]

        return None

ht = HashTable(10)

ht.insert("SKU101", "Laptop")
ht.insert("SKU110", "Mobile")

print("Collision Demonstration:")
print("SKU101 Index:", ht.hash_function("SKU101"))
print("SKU110 Index:", ht.hash_function("SKU110"))

print("Chaining:", ht.table[ht.hash_function("SKU101")])

skus = {
    f"SKU{i}": f"Product{i}"
    for i in range(100000)
}
custom_ht = HashTable(200003)

for key, value in skus.items():
    custom_ht.insert(key, value)

builtin_dict = skus.copy()

target = "SKU99999"

start = time.perf_counter()

result1 = custom_ht.search(target)

custom_time = time.perf_counter() - start

start = time.perf_counter()

result2 = builtin_dict.get(target)

builtin_time = time.perf_counter() - start

print("\nLookup Results:")
print("Custom Hash Table:", result1)
print("Built-in Dictionary:", result2)

print("\nPerformance Comparison:")
print(f"Custom Hash Table: {custom_time:.10f} seconds")
print(f"Built-in Dictionary: {builtin_time:.10f} seconds")

#TASK - 3
print("-----Task-3-----")

from collections import deque


class Graph:
    def __init__(self):
        self.graph = {}

    def add_edge(self, u, v):
        self.graph.setdefault(u, []).append(v)
        self.graph.setdefault(v, [])
    def display(self):
        for node, neighbors in self.graph.items():
            print(node, "->", neighbors)
    def bfs(self):
        indegree = {node: 0 for node in self.graph}

        for node in self.graph:
            for neighbor in self.graph[node]:
                indegree[neighbor] += 1

        queue = deque(
            node for node in indegree if indegree[node] == 0
        )

        order = []

        while queue:
            node = queue.popleft()
            order.append(node)

            for neighbor in self.graph[node]:
                indegree[neighbor] -= 1

                if indegree[neighbor] == 0:
                    queue.append(neighbor)

        if len(order) != len(self.graph):
            print("Cycle detected! No valid deployment order.")
        else:
            print("BFS Deployment Order:", order)
    def dfs(self):
        visited = set()
        path = set()
        order = []
        cycle = False

        def visit(node):
            nonlocal cycle

            if node in path:
                cycle = True
                return

            if node in visited:
                return

            path.add(node)

            for neighbor in self.graph[node]:
                visit(neighbor)

                if cycle:
                    return

            path.remove(node)
            visited.add(node)
            order.append(node)

        for node in self.graph:
            if node not in visited:
                visit(node)

            if cycle:
                break

        if cycle:
            print("Cycle detected! No valid deployment order.")
        else:
            print("DFS Deployment Order:", order[::-1])


# Main Program
g = Graph()

g.add_edge("Cart", "Pricing")
g.add_edge("Pricing", "Inventory")
g.add_edge("Inventory", "Database")
g.add_edge("Cart", "Authentication")
g.add_edge("Authentication", "Database")

print("Service Dependencies:")
g.display()

print("\nDeployment using BFS:")
g.bfs()

print("\nDeployment using DFS:")
g.dfs()

# Demonstrate circular dependency
print("\nAdding Circular Dependency:")
g.add_edge("Database", "Cart")

print("\nDeployment using BFS:")
g.bfs()

print("\nDeployment using DFS:")
g.dfs()

#TASK - 4
print("------Task-4-----")

# Traffic requests for 24 hours
traffic = [
    120, 150, 180, 200, 250, 300,
    450, 500, 600, 700, 650, 550,
    400, 350, 300, 250, 200, 180,
    150, 130, 120, 100, 90, 80
]
k = 3
window_sum = sum(traffic[:k])
max_sum = window_sum

start_index = 0

for i in range(k, len(traffic)):
    window_sum += traffic[i] - traffic[i - k]

    if window_sum > max_sum:
        max_sum = window_sum
        start_index = i - k + 1

print("Busiest 3-Hour Window:")

print("Starting Hour:", start_index + 1)
print("Ending Hour:", start_index + k)

print("Maximum Requests:", max_sum)


#Task - 5
print("-----Task-5-----")

# Sorted order values
orders = [100, 200, 300, 400, 500, 600, 700, 800]

gift_card = 900

left = 0
right = len(orders) - 1

pairs = []

while left < right:
    total = orders[left] + orders[right]

    if total == gift_card:
        pairs.append((orders[left], orders[right]))
        left += 1
        right -= 1

    elif total < gift_card:
        left += 1

    else:
        right -= 1

# Display results
print("Gift Card Value:", gift_card)

print("\nMatching Order Pairs:")

if pairs:
    for a, b in pairs:
        print(a, "+", b, "=", gift_card)
else:
    print("No matching pairs found")

print("\nTotal Pairs:", len(pairs))
