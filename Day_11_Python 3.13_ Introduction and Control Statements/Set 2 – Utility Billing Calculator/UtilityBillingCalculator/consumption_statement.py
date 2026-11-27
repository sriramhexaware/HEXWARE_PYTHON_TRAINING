
def generate_consumption_statement(consumption):

    print("\n========== 12 MONTH CONSUMPTION STATEMENT ==========")

    print(f"{'Month':<15}{'Units':>12}")

    for month, units in enumerate(consumption, start=1):
        print(f"{month:<15}{units:>12.2f}")

    print("=" * 40)
