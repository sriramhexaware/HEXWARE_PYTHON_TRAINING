
from slab_calculator import calculate_slab_bill
from consumer_charges import get_fixed_charge
from bill_adjustments import calculate_final_bill
from reading_handler import accept_readings
from bill_printer import print_bill


if __name__ == "__main__":

    print("===== UTILITY BILLING CALCULATOR =====")

    category = input("Enter consumer category: ").strip()

    if category.lower() not in ["domestic", "commercial", "industrial"]:
        print("Invalid consumer category!")
        exit()

    readings = accept_readings()

    for units in readings:

        electricity_charge = calculate_slab_bill(units)

        fixed_charge = get_fixed_charge(category)

        is_late = input("Late payment? (y/n): ").strip().lower() == "y"

        is_online = input("Online payment? (y/n): ").strip().lower() == "y"

        final_bill = calculate_final_bill(
            electricity_charge,
            fixed_charge,
            is_late,
            is_online
        )

        print_bill(
            category,
            units,
            electricity_charge,
            fixed_charge,
            is_late,
            is_online,
            final_bill
        )
