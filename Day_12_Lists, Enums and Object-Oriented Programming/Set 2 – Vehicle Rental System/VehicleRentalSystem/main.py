from models.customer import Customer
from models.rental import Rental

from vehicles.car import Car
from vehicles.bike import Bike
from vehicles.van import Van

from services.rental_service import RentalService
from services.billing_service import BillingService
from services.report_service import ReportService


if __name__ == "__main__":

    # Create customers
    customer1 = Customer("C101", "Sriram")
    customer2 = Customer("C102", "Arun")
    customer3 = Customer("C103", "Kumar")

    # Create vehicles
    car = Car("TN38AB1234", 15000)
    bike = Bike("TN37XY5678", 8000)
    van = Van("TN39CD9876", 20000)

    # Create rentals
    rental1 = Rental("R101", customer1, car, 5)
    rental2 = Rental("R102", customer2, bike, 3)
    rental3 = Rental("R103", customer3, van, 2)

    # Manage rentals
    rental_service = RentalService()

    rental_service.add_rental(rental1)
    rental_service.add_rental(rental2)
    rental_service.add_rental(rental3)

    # Display rental report
    report_service = ReportService()

    report_service.display_rentals(rental_service.rentals)

    # Calculate total revenue
    total_revenue = rental_service.calculate_total_revenue()

    print("\nTotal Rentals:", len(rental_service.rentals))
    print(f"Total Rental Revenue: ₹{total_revenue:,.2f}")

    # Generate bill
    billing_service = BillingService()

    late_days = 2

    rental_amount = billing_service.calculate_bill(rental1)

    final_bill = billing_service.calculate_final_bill(
        rental1,
        late_days
    )

    late_fee = final_bill - rental_amount

    print("\nBILLING DETAILS -", rental1.rental_id)
    print(f"Rental Amount: ₹{rental_amount:,.2f}")
    print(f"Late Fee ({late_days} days): ₹{late_fee:,.2f}")
    print(f"Final Bill: ₹{final_bill:,.2f}")