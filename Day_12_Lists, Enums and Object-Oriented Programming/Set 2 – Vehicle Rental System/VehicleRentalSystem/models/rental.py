from vehicles.vehicle import Vehicle
from models.customer import Customer


class Rental:

    def __init__(self, rental_id, customer, vehicle, days):

        if not isinstance(customer, Customer):
            raise TypeError("Invalid customer object")

        if not isinstance(vehicle, Vehicle):
            raise TypeError("Invalid vehicle object")

        if not isinstance(days, int) or isinstance(days, bool) or days <= 0:
            raise ValueError("Rental days must be a positive integer")

        self.rental_id = rental_id
        self.customer = customer
        self.vehicle = vehicle
        self.days = days

    def calculate_rental_amount(self):

        return self.vehicle.daily_rate() * self.days

    def calculate_late_fee(self, late_days):

        return self.vehicle.late_fee(late_days)