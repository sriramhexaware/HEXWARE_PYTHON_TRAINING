
# TASK 1: BINARY SEARCH TREE
print()
print("-----TASK-1-----")
print()
class Node:
    def __init__(self, claim_id):
        self.claim_id = claim_id
        self.left = None
        self.right = None


class BST:
    def __init__(self):
        self.root = None

    def insert(self, claim_id):
        self.root = self._insert(self.root, claim_id)

    def _insert(self, root, claim_id):
        if root is None:
            return Node(claim_id)

        if claim_id < root.claim_id:
            root.left = self._insert(root.left, claim_id)
        elif claim_id > root.claim_id:
            root.right = self._insert(root.right, claim_id)

        return root

    def search(self, claim_id):
        current = self.root

        while current:
            if current.claim_id == claim_id:
                return True
            elif claim_id < current.claim_id:
                current = current.left
            else:
                current = current.right

        return False

    def inorder(self, root):
        if root:
            self.inorder(root.left)
            print(root.claim_id, end=" ")
            self.inorder(root.right)

    def preorder(self, root):
        if root:
            print(root.claim_id, end=" ")
            self.preorder(root.left)
            self.preorder(root.right)

    def postorder(self, root):
        if root:
            self.postorder(root.left)
            self.postorder(root.right)
            print(root.claim_id, end=" ")


# Sample claim IDs
claim_ids = [105, 102, 108, 101, 104, 107, 110]

bst = BST()

for claim_id in claim_ids:
    bst.insert(claim_id)

print("\nInorder Traversal:")
bst.inorder(bst.root)

print("\nPreorder Traversal:")
bst.preorder(bst.root)

print("\nPostorder Traversal:")
bst.postorder(bst.root)

# Search test
print("\n\nSearch 104:", bst.search(104))
print("Search 999:", bst.search(999))

# Empty tree test
empty_bst = BST()
print("Search in empty tree:", empty_bst.search(100))
print()


# TASK 2: HASHING - DUPLICATE CLAIM DETECTION
print("-----TASK-2-----")
print()
def normalize(value):
    return value.replace(" ", "").lower()


def detect_duplicates(claims):
    claim_hash = {}
    duplicates = []

    for claim in claims:
        key = (
            normalize(claim["policy_no"]),
            claim["incident_date"]
        )

        if key in claim_hash:
            duplicates.append(claim["claim_id"])
        else:
            claim_hash[key] = claim["claim_id"]

    return duplicates


# Sample claim data
claims = [
    {"claim_id": 101, "policy_no": "POL 123", "incident_date": "2026-11-10"},
    {"claim_id": 102, "policy_no": "pol123", "incident_date": "2026-11-10"},
    {"claim_id": 103, "policy_no": "POL456", "incident_date": "2026-11-11"},
    {"claim_id": 104, "policy_no": "POL 456", "incident_date": "2026-11-11"},
    {"claim_id": 105, "policy_no": "POL789", "incident_date": "2026-11-12"},
    {"claim_id": 106, "policy_no": "POL789", "incident_date": "2026-11-13"},
    {"claim_id": 107, "policy_no": "POL 321", "incident_date": "2026-11-14"}
]

duplicates = detect_duplicates(claims)

print("\nDuplicate Claims:")
print(duplicates)

# Empty input test
print("Empty Input:", detect_duplicates([]))

# No duplicate test
unique_claims = [
    {"claim_id": 201, "policy_no": "POL111", "incident_date": "2026-11-10"},
    {"claim_id": 202, "policy_no": "POL222", "incident_date": "2026-11-11"}
]

print("No Duplicate Test:", detect_duplicates(unique_claims))
print()


# TASK 3: GRAPH - BFS AND DFS
print("-----TASK-3-----")
print()
class Graph:
    def __init__(self):
        self.graph = {}

    def add_edge(self, source, destination):
        self.graph.setdefault(source, [])
        self.graph.setdefault(destination, [])
        self.graph[source].append(destination)

    def bfs(self, start, end):
        if start not in self.graph or end not in self.graph:
            return []

        queue = [[start]]
        visited = {start}

        while queue:
            path = queue.pop(0)
            node = path[-1]

            if node == end:
                return path

            for neighbour in self.graph[node]:
                if neighbour not in visited:
                    visited.add(neighbour)
                    queue.append(path + [neighbour])

        return []

    def has_cycle(self):
        visited = set()
        rec_stack = set()

        def dfs(node):
            visited.add(node)
            rec_stack.add(node)

            for neighbour in self.graph[node]:
                if neighbour not in visited:
                    if dfs(neighbour):
                        return True
                elif neighbour in rec_stack:
                    return True

            rec_stack.remove(node)
            return False

        for node in self.graph:
            if node not in visited:
                if dfs(node):
                    return True

        return False

# Create approval graph
g = Graph()

g.add_edge("Registration", "Assessment")
g.add_edge("Assessment", "Surveyor")
g.add_edge("Assessment", "Settlement")
g.add_edge("Surveyor", "Settlement")
path = g.bfs("Registration", "Settlement")

print("\nShortest Approval Path:")
print(" -> ".join(path) if path else "No path found")

print("Cycle Exists:", g.has_cycle())

g.add_edge("Settlement", "Assessment")

print("Cycle After Adding Loop:", g.has_cycle())
empty_graph = Graph()
print("Empty Graph Cycle:", empty_graph.has_cycle())

print("Missing Stage Path:", g.bfs("Registration", "Unknown"))
print()


# TASK 4: SLIDING WINDOW - LONGEST CONSECUTIVE DAYS
print("-----Task-4-----")
def longest_claim_spike(claims):
    max_days = 0
    current_days = 0
    start = -1
    best_start = -1

    for i in range(len(claims)):
        if claims[i] > 100:
            current_days += 1

            if current_days == 1:
                start = i

            if current_days > max_days:
                max_days = current_days
                best_start = start
        else:
            current_days = 0

    if max_days == 0:
        return 0, []

    return max_days, list(
        range(best_start + 1, best_start + max_days + 1)
    )


# Sample daily claim counts
daily_claims = [85, 120, 135, 150, 90, 110, 125, 140, 160, 95]

days, period = longest_claim_spike(daily_claims)

print("\nLongest Consecutive Claim Spike:")
print("Number of Days:", days)
print("Days:", period)
print("Empty Input:", longest_claim_spike([]))
print("No Spike:", longest_claim_spike([50, 80, 100, 90]))
print("All Days Exceed:", longest_claim_spike([110, 120, 130]))
print()


# TASK 5: TWO POINTERS - MERGE SORTED CLAIM LISTS
print("-----Task-5-----")
print()

def merge_claims(region1, region2):
    i = 0
    j = 0
    merged = []

    while i < len(region1) and j < len(region2):
        if region1[i] <= region2[j]:
            merged.append(region1[i])
            i += 1
        else:
            merged.append(region2[j])
            j += 1

    while i < len(region1):
        merged.append(region1[i])
        i += 1

    while j < len(region2):
        merged.append(region2[j])
        j += 1

    return merged


# Sample regional claim lists
region1 = [101, 104, 107, 110, 115]
region2 = [102, 103, 108, 112, 120]

result = merge_claims(region1, region2)

print("\nMerged Claim List:")
print(result)
print("Both Empty:", merge_claims([], []))
print("Region 1 Empty:", merge_claims([], [102, 104, 106]))
print("Region 2 Empty:", merge_claims([101, 103, 105], []))
print("Duplicate Test:", merge_claims([101, 103, 105], [102, 103, 106]))

