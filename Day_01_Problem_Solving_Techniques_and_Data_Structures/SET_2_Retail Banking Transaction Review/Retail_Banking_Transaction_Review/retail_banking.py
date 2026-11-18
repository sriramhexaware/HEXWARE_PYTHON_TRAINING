# Task 1: Binary Search


# TASK 1 - BINARY SEARCH

import csv

with open("transactions.csv", "r") as file:
    transactions = list(csv.DictReader(file))

ids = sorted(int(row["transactionId"]) for row in transactions)


# Binary Search
def binary_search(arr, target):
    low, high = 0, len(arr) - 1
    comparisons = 0

    while low <= high:
        mid = (low + high) // 2
        comparisons += 1

        if arr[mid] == target:
            return mid, comparisons
        elif arr[mid] < target:
            low = mid + 1
        else:
            high = mid - 1

    return -1, comparisons


# Linear Search
def linear_search(arr, target):
    comparisons = 0

    for i in range(len(arr)):
        comparisons += 1

        if arr[i] == target:
            return i, comparisons

    return -1, comparisons


# Test searches
target = ids[len(ids) // 2]

print("--- Binary Search ---")

for label, value in [
    ("Best Case", ids[len(ids) // 2]),
    ("Average Case", ids[len(ids) // 3]),
    ("Worst Case", -1)
]:
    position, count = binary_search(ids, value)
    print(label, "Comparisons:", count)

print("\n--- Linear Search ---")

position, count = linear_search(ids, target)
print("Comparisons:", count)


# TASK 2 - SORTING CUSTOMER STATEMENT

from datetime import datetime
import time

account_id = input("Enter Account ID: ")

statement = [
    row for row in transactions
    if row["accountId"] == account_id
]

def get_date(row):
    return datetime.strptime(
        row["postingDate"], "%Y-%m-%d %H:%M:%S"
    )


# Insertion Sort 
def insertion_sort(data):
    arr = data.copy()

    for i in range(1, len(arr)):
        key = arr[i]
        j = i - 1

        while j >= 0 and get_date(arr[j]) > get_date(key):
            arr[j + 1] = arr[j]
            j -= 1

        arr[j + 1] = key

    return arr


# Merge Sort 
def merge_sort(data):
    if len(data) <= 1:
        return data

    mid = len(data) // 2

    left = merge_sort(data[:mid])
    right = merge_sort(data[mid:])

    result = []
    i = j = 0

    while i < len(left) and j < len(right):
        if get_date(left[i]) <= get_date(right[j]):
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1

    return result + left[i:] + right[j:]


# Benchmark
start = time.perf_counter()
insertion_result = insertion_sort(statement)
insertion_time = time.perf_counter() - start

start = time.perf_counter()
merge_result = merge_sort(statement)
merge_time = time.perf_counter() - start

print("\n--- Customer Statement ---")

for row in merge_result:
    print(row)

print("\n--- Sorting Results ---")
print("Insertion Sort:", round(insertion_time, 6), "seconds")
print("Merge Sort:", round(merge_time, 6), "seconds")

print("\nSorting Correctness:")
print("Insertion:", insertion_result == merge_result)
print("Merge:", merge_result == insertion_result)


# TASK 3 - DUPLICATE TRANSACTION DETECTION

from collections import defaultdict, deque

def detect_duplicates(transactions):
    groups = defaultdict(deque)
    duplicates = []

    sorted_transactions = sorted(
        transactions,
        key=lambda x: get_date(x)
    )

    for row in sorted_transactions:
        key = (
            row["accountId"],
            float(row["amount"]),
            row["merchant"]
        )

        current_time = get_date(row)
        window = groups[key]

        while window and (current_time - window[0][0]).total_seconds() > 60:
            window.popleft()

        if window:
            duplicates.append(row)

        window.append((current_time, row))

    return duplicates


duplicates = detect_duplicates(transactions)

print("\n--- Duplicate Transactions ---")
print("Total Duplicates:", len(duplicates))

for row in duplicates:
    print(row)


# TASK 4 - CUSTOM QUEUE AND STACK

# Custom Queue 
class CustomQueue:
    def __init__(self):
        self.queue = []

    def enqueue(self, transaction):
        self.queue.append(transaction)

    def dequeue(self):
        return self.queue.pop(0) if self.queue else None


# Custom Stack 
class CustomStack:
    def __init__(self):
        self.stack = []

    def push(self, adjustment):
        self.stack.append(adjustment)

    def pop(self):
        return self.stack.pop() if self.stack else None


# Manual Queue
review_queue = CustomQueue()

for transaction in transactions:
    review_queue.enqueue(transaction)

print("\n--- Manual Review Queue ---")
print("Total Pending:", len(review_queue.queue))
print("First Reviewed:", review_queue.dequeue())


#Manual Stack
adjustment_stack = CustomStack()

def apply_adjustment(transaction):
    adjustment_stack.push(transaction)

def reverse_adjustment():
    return adjustment_stack.pop()

if transactions:
    apply_adjustment(transactions[-1])

print("\n--- Adjustment Stack ---")
print("Reversed Adjustment:", reverse_adjustment())


# TASK 5 - HIGHEST AND LOWEST TRANSACTION

# Brute Force Approach
def brute_force(data):
    amounts = [float(row["amount"]) for row in data]

    minimum = amounts[0]
    maximum = amounts[0]

    for amount in amounts:
        if amount < minimum:
            minimum = amount

        if amount > maximum:
            maximum = amount

    return minimum, maximum


# Divide and Conquer Approach
def divide_conquer(data, low, high):
    if low == high:
        amount = float(data[low]["amount"])
        return amount, amount

    if high == low + 1:
        a = float(data[low]["amount"])
        b = float(data[high]["amount"])
        return min(a, b), max(a, b)

    mid = (low + high) // 2

    left_min, left_max = divide_conquer(data, low, mid)
    right_min, right_max = divide_conquer(data, mid + 1, high)

    return min(left_min, right_min), max(left_max, right_max)


# Compare Results
if transactions:
    brute_min, brute_max = brute_force(transactions)

    dc_min, dc_max = divide_conquer(
        transactions, 0, len(transactions) - 1
    )

    print("\n--- Brute Force ---")
    print("Minimum Amount:", brute_min)
    print("Maximum Amount:", brute_max)

    print("\n--- Divide and Conquer ---")
    print("Minimum Amount:", dc_min)
    print("Maximum Amount:", dc_max)

    print("\nResults Match:", (brute_min, brute_max) == (dc_min, dc_max))
else:
    print("No transactions found.")


