
import csv
import time
import random

# TASK 1: LINEAR SEARCH VS BINARY SEARCH

# Read patient records from CSV
with open("patients.csv", "r") as file:
    reader = csv.DictReader(file)
    patients = list(reader)


# Linear Search
def linear_search(patients, target):
    for patient in patients:
        if int(patient["patient_id"]) == target:
            return patient
    return None


# Binary Search
def binary_search(patients, target):
    low = 0
    high = len(patients) - 1

    while low <= high:
        mid = (low + high) // 2
        patient_id = int(patients[mid]["patient_id"])

        if patient_id == target:
            return patients[mid]
        elif patient_id < target:
            low = mid + 1
        else:
            high = mid - 1

    return None


patients.sort(key=lambda x: int(x["patient_id"]))

targets = random.choices(
    [int(p["patient_id"]) for p in patients],
    k=1000
)
start = time.perf_counter()

for target in targets:
    linear_search(patients, target)

linear_time = time.perf_counter() - start
start = time.perf_counter()

for target in targets:
    binary_search(patients, target)

binary_time = time.perf_counter() - start

# Display Results
print("\nTASK 1: SEARCHING COMPARISON")
print("Linear Search Time:", linear_time)
print("Binary Search Time:", binary_time)

# TASK 2: SELECTION SORT VS QUICK SORT

with open("appointments.csv", "r") as file:
    reader = csv.DictReader(file)
    appointments = list(reader)


def selection_sort(data):
    arr = data.copy()
    swaps = 0

    for i in range(len(arr)):
        min_index = i

        for j in range(i + 1, len(arr)):
            key1 = (int(arr[j]["urgency"]), arr[j]["arrival_time"])
            key2 = (int(arr[min_index]["urgency"]), arr[min_index]["arrival_time"])

            if key1 < key2:
                min_index = j

        if min_index != i:
            arr[i], arr[min_index] = arr[min_index], arr[i]
            swaps += 1

    return arr, swaps


def quick_sort(data):
    arr = data.copy()
    swaps = [0]

    def partition(low, high):
        pivot = (
            int(arr[high]["urgency"]),
            arr[high]["arrival_time"]
        )

        i = low - 1

        for j in range(low, high):
            key = (
                int(arr[j]["urgency"]),
                arr[j]["arrival_time"]
            )

            if key <= pivot:
                i += 1

                if i != j:
                    arr[i], arr[j] = arr[j], arr[i]
                    swaps[0] += 1

        if i + 1 != high:
            arr[i + 1], arr[high] = arr[high], arr[i + 1]
            swaps[0] += 1

        return i + 1

    def sort(low, high):
        if low < high:
            pivot_index = partition(low, high)
            sort(low, pivot_index - 1)
            sort(pivot_index + 1, high)

    sort(0, len(arr) - 1)

    return arr, swaps[0]


# Selection Sort measurement
start = time.perf_counter()
selection_result, selection_swaps = selection_sort(appointments)
selection_time = time.perf_counter() - start

# Quick Sort measurement
start = time.perf_counter()
quick_result, quick_swaps = quick_sort(appointments)
quick_time = time.perf_counter() - start


print("\nTASK 2: SORTING COMPARISON")

print("\nSelection Sort")
print("Swaps:", selection_swaps)
print("Time:", selection_time)

print("\nQuick Sort")
print("Swaps:", quick_swaps)
print("Time:", quick_time)


# Display sorted appointments
print("\nSorted Appointments:")
for appointment in quick_result:
    print(
        appointment["appointment_id"],
        appointment["urgency"],
        appointment["arrival_time"]
    )

# TASK 3: DETECT DOUBLE-BOOKED APPOINTMENTS

with open("appointments.csv", "r") as file:
    reader = csv.DictReader(file)
    appointments = list(reader)


def detect_double_booking(appointments):
    booked_slots = set()
    duplicates = []

    for appointment in appointments:
        key = (
            appointment["patient_id"],
            appointment["start_time"]
        )

        if key in booked_slots:
            duplicates.append(appointment)
        else:
            booked_slots.add(key)

    return duplicates


duplicates = detect_double_booking(appointments)

print("\nTASK 3: DOUBLE BOOKING DETECTION")

if duplicates:
    print("Double-booked appointments found:")

    for appointment in duplicates:
        print(
            appointment["patient_id"],
            appointment["appointment_id"],
            appointment["start_time"]
        )
else:
    print("No double-booked appointments found.")

# TASK 4: QUEUE AND STACK IMPLEMENTATION

with open("patients.csv", "r") as file:
    reader = csv.DictReader(file)
    patients = list(reader)


# QUEUE

class Queue:
    def __init__(self):
        self.items = []

    def enqueue(self, patient):
        self.items.append(patient)

    def dequeue(self):
        if not self.items:
            return None
        return self.items.pop(0)

    def display(self):
        for patient in self.items:
            print(patient["patient_id"], patient["patient_name"])

# STACK

class Stack:
    def __init__(self):
        self.items = []

    def push(self, patient):
        self.items.append(patient)

    def pop(self):
        if not self.items:
            return None
        return self.items.pop()

    def display(self):
        for patient in reversed(self.items):
            print(patient["patient_id"], patient["patient_name"])


walkin_queue = Queue()

for patient in patients[:5]:
    walkin_queue.enqueue(patient)

print("\nTASK 4: WALK-IN QUEUE")

print("Current Queue:")
walkin_queue.display()

served_patient = walkin_queue.dequeue()

print("\nServed Patient:")
if served_patient:
    print(served_patient["patient_id"], served_patient["patient_name"])

print("\nQueue After Serving:")
walkin_queue.display()

recent_patients = Stack()

for patient in patients[:5]:
    recent_patients.push(patient)

print("\nRECENTLY VIEWED PATIENTS")

print("Current Stack:")
recent_patients.display()

last_viewed = recent_patients.pop()

print("\nLast Viewed Patient:")
if last_viewed:
    print(last_viewed["patient_id"], last_viewed["patient_name"])

print("\nStack After Pop:")
recent_patients.display()

# TASK 5: DYNAMIC PROGRAMMING VS GREEDY

from bisect import bisect_right

with open("appointments.csv", "r") as file:
    reader = csv.DictReader(file)
    appointments = list(reader)


def dynamic_programming(appointments):

    appointments = sorted(
        appointments,
        key=lambda x: x["end_time"]
    )

    n = len(appointments)

    end_times = [a["end_time"] for a in appointments]

    dp = [0] * (n + 1)

    for i in range(1, n + 1):

        current = appointments[i - 1]

        previous = bisect_right(
            end_times,
            current["start_time"],
            0,
            i - 1
        )

        include = int(current["duration"]) + dp[previous]
        exclude = dp[i - 1]

        dp[i] = max(include, exclude)

    return dp[n]


def greedy_algorithm(appointments):

    appointments = sorted(
        appointments,
        key=lambda x: x["end_time"]
    )

    total_duration = 0
    last_end = "00:00"

    for appointment in appointments:

        if appointment["start_time"] >= last_end:

            total_duration += int(appointment["duration"])
            last_end = appointment["end_time"]

    return total_duration

doctor_id = appointments[0]["doctor_id"]

doctor_appointments = [
    a for a in appointments
    if a["doctor_id"] == doctor_id
]

dp_result = dynamic_programming(doctor_appointments)
greedy_result = greedy_algorithm(doctor_appointments)

print("\nTASK 5: APPOINTMENT SCHEDULING")

print("Doctor ID:", doctor_id)

print("Maximum Duration using DP:", dp_result, "minutes")

print("Total Duration using Greedy:", greedy_result, "minutes")
