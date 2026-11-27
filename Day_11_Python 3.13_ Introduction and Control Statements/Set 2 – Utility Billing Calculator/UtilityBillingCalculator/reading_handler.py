
import math


def accept_readings():

    readings = []

    while True:

        value = input("Enter meter reading (or q to quit): ").strip()

        if value.lower() == "q":
            break

        try:
            units = float(value)

            if not math.isfinite(units) or units < 0:
                print("Invalid reading! Enter a valid non-negative number.")
                continue

            readings.append(units)

        except ValueError:
            print("Invalid input! Enter a numeric reading or q.")

    return readings
