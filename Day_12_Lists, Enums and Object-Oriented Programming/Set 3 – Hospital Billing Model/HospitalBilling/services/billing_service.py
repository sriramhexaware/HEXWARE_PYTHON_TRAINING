class BillingService:

    def __init__(self):
        self.visits = []

    def add_visit(self, visit):
        self.visits.append(visit)

    def display_monthly_totals(self, monthly_totals):

        months = ["January", "February", "March"]

        print("\nDEPARTMENT-WISE MONTHLY TOTALS")
        print("-" * 60)

        print(f"{'Department':<15}", end="")

        for month in months:
            print(f"{month:<15}", end="")

        print()

        for department in monthly_totals:

            print(f"{department[0]:<15}", end="")

            for amount in department[1]:
                print(f"₹{amount:<14,.2f}", end="")

            print()

    def generate_bill_summary(self):

        total = 0

        print("\nHOSPITAL BILL SUMMARY")
        print("-" * 65)

        for visit in self.visits:

            amount = visit.calculate_bill()
            total += amount

            print(
                f"{visit.patient.name:<15}"
                f"{visit.doctor.name:<15}"
                f"{visit.visit_type.value:<15}"
                f"₹{amount:,.2f}"
            )

        print("-" * 65)
        print(f"Total Billing Amount: ₹{total:,.2f}")

        return total