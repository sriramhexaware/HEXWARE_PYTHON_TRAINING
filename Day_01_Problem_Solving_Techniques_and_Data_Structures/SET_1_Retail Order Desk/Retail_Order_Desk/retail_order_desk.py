
# Task - 1

import csv
import time

with open("orders.csv", "r") as file:
    orders = list(csv.DictReader(file))

# Linear Search
def linear_search(order_id):
    for order in orders:
        if int(order["orderId"]) == order_id:
            return order
    return None

# Binary Search
sorted_orders = sorted(orders, key=lambda x: int(x["orderId"]))

def binary_search(order_id):
    low, high = 0, len(sorted_orders) - 1

    while low <= high:
        mid = (low + high) // 2
        current = int(sorted_orders[mid]["orderId"])

        if current == order_id:
            return sorted_orders[mid]
        elif current < order_id:
            low = mid + 1
        else:
            high = mid - 1

    return None

target = 50000

start = time.perf_counter()
result1 = linear_search(target)
linear_time = time.perf_counter() - start

start = time.perf_counter()
result2 = binary_search(target)
binary_time = time.perf_counter() - start

print("Linear Search:", result1)
print("Linear Time:", linear_time)

print("Binary Search:", result2)
print("Binary Time:", binary_time)


# TASK 2 - SORTING ALGORITHMS

import time

# Load orders from existing CSV
orders = [
    {**row, "amount": float(row["amount"])}
    for row in csv.DictReader(open("orders.csv"))
]

# Bubble Sort 
def bubble_sort(data):
    arr = data.copy()

    for i in range(len(arr)):
        for j in range(len(arr) - i - 1):
            if arr[j]["amount"] < arr[j + 1]["amount"]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]

        if i < 3:
            print("Bubble Pass", i + 1,
                  [x["amount"] for x in arr[:5]])

    return arr


# Merge Sort 
def merge_sort(arr):
    if len(arr) <= 1:
        return arr

    mid = len(arr) // 2
    left = merge_sort(arr[:mid])
    right = merge_sort(arr[mid:])

    result = []
    i = j = 0

    while i < len(left) and j < len(right):
        if left[i]["amount"] >= right[j]["amount"]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1

    return result + left[i:] + right[j:]


# Benchmark on 10,000 records
sample = orders[:10000]

start = time.perf_counter()
bubble_result = bubble_sort(sample)
bubble_time = time.perf_counter() - start

start = time.perf_counter()
merge_result = merge_sort(sample)
merge_time = time.perf_counter() - start

start = time.perf_counter()
builtin_result = sorted(
    sample,
    key=lambda x: x["amount"],
    reverse=True
)
builtin_time = time.perf_counter() - start

print("\n--- Sorting Results ---")
print("Bubble Sort:", round(bubble_time, 5), "seconds")
print("Merge Sort:", round(merge_time, 5), "seconds")
print("Built-in Sort:", round(builtin_time, 5), "seconds")

print("\nSorting Correctness:")
print("Bubble:", bubble_result == builtin_result)
print("Merge:", merge_result == builtin_result)


# TASK 3 - DUPLICATE ORDER DETECTION

from collections import defaultdict

def detect_duplicates(orders):
    seen = defaultdict(list)
    duplicates = []

    for order in orders:
        minute = order["createdAt"][:16]

        key = (
            order["customerId"],
            float(order["amount"]),
            minute
        )

        if key in seen:
            duplicates.append(order)

        seen[key].append(order)

    return duplicates


duplicates = detect_duplicates(orders)

print("\n--- Duplicate Order Detection ---")
print("Total Duplicate Orders:", len(duplicates))

for order in duplicates[:10]:
    print(order)


# TASK 4 - STACK AND QUEUE

from collections import deque

# Custom Stack
class CustomStack:
    def __init__(self):
        self.stack = []

    def push(self, item):
        self.stack.append(item)

    def pop(self):
        return self.stack.pop() if self.stack else None


# Custom Queue
class CustomQueue:
    def __init__(self):
        self.queue = []

    def enqueue(self, item):
        self.queue.append(item)

    def dequeue(self):
        return self.queue.pop(0) if self.queue else None


# Stack 
stack = CustomStack()

stack.push({"orderId": 1001, "amount": 2000})
stack.push({"orderId": 1002, "amount": 3000})
stack.push({"orderId": 1002, "amount": 3500})

print("\n--- Custom Stack ---")
print("Undo:", stack.pop())


# Queue 
queue = CustomQueue()

for order in orders[:5]:
    queue.enqueue(order)

print("\n--- Custom Queue ---")
print("Dispatched:", queue.dequeue())


# Built-in Stack
builtin_stack = []

builtin_stack.append(1001)
builtin_stack.append(1002)

print("\n--- Built-in Stack ---")
print("Undo:", builtin_stack.pop())


# Built-in Queue
builtin_queue = deque()

builtin_queue.extend(orders[:5])

print("\n--- Built-in Queue ---")
print("Dispatched:", builtin_queue.popleft())



# TASK 5 - REFUND CALCULATION

# Greedy Approach
def greedy_refund(amount, coins):
    result = []

    for coin in sorted(coins, reverse=True):
        count = amount // coin
        result.append((coin, count))
        amount %= coin

    if amount != 0:
        return None

    return result


# Dynamic Programming Approach
def dp_refund(amount, coins):
    dp = [float('inf')] * (amount + 1)
    dp[0] = 0

    for i in range(1, amount + 1):
        for coin in coins:
            if coin <= i:
                dp[i] = min(dp[i], dp[i - coin] + 1)

    if dp[amount] == float('inf'):
        return None

    result = []
    remaining = amount

    while remaining > 0:
        for coin in coins:
            if coin <= remaining and dp[remaining] == dp[remaining - coin] + 1:
                result.append(coin)
                remaining -= coin
                break

    return result


# Greedy example
amount = 63
coins = [25, 10, 5, 1]

greedy = greedy_refund(amount, coins)

print("\n--- Greedy Refund ---")
print("Amount:", amount)
print("Coins:", greedy)
print("Total Coins:", sum(count for coin, count in greedy))


# Greedy Failure Example
amount = 6
coins = [4, 3, 1]

greedy = greedy_refund(amount, coins)
optimal = dp_refund(amount, coins)

print("\n--- Greedy Failure Example ---")
print("Amount:", amount)
print("Denominations:", coins)
print("Greedy:", greedy)
print("DP Optimal:", optimal)
print("Minimum Coins:", len(optimal))

