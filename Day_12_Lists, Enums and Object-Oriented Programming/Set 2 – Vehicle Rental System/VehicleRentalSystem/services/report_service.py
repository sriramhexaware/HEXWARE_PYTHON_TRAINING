class ReportService:

    def display_rentals(self, rentals):

        print("\nVEHICLE RENTAL REPORT")
        print("-" * 75)

        print(
            f"{'Rental ID':<12}"
            f"{'Customer':<15}"
            f"{'Vehicle':<12}"
            f"{'Days':<8}"
            f"{'Amount':>12}"
        )

        print("-" * 75)

        for rental in rentals:

            print(
                f"{rental.rental_id:<12}"
                f"{rental.customer.customer_name:<15}"
                f"{rental.vehicle.vehicle_type.value:<12}"
                f"{rental.days:<8}"
                f"{rental.calculate_rental_amount():>12.2f}"
            )

        print("-" * 75)