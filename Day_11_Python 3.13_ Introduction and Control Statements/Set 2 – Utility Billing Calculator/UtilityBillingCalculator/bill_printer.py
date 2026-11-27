
def print_bill(
    category,
    units,
    electricity_charge,
    fixed_charge,
    is_late,
    is_online,
    final_bill
):

    initial_bill = electricity_charge + fixed_charge

    surcharge = initial_bill * 0.10 if is_late else 0.0

    subtotal = initial_bill + surcharge

    rebate = subtotal * 0.05 if is_online else 0.0

    print("\n" + "=" * 50)
    print(f"{'ELECTRICITY BILL':^50}")
    print("=" * 50)

    print(f"{'Consumer Category':<30}: {category.title()}")
    print(f"{'Consumption':<30}: {units:.2f} units")

    print("-" * 50)

    print(f"{'Electricity Charge':<30}: ₹{electricity_charge:>10.2f}")
    print(f"{'Fixed Charge':<30}: ₹{fixed_charge:>10.2f}")
    print(f"{'Initial Bill':<30}: ₹{initial_bill:>10.2f}")
    print(f"{'Late Surcharge':<30}: ₹{surcharge:>10.2f}")
    print(f"{'Online Rebate':<30}: ₹{rebate:>10.2f}")

    print("-" * 50)

    print(f"{'FINAL AMOUNT':<30}: ₹{final_bill:>10.2f}")

    print("=" * 50)
