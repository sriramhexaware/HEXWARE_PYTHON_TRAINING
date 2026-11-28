from models.rental import Rental


class RentalService:

    def __init__(self):
        self.rentals = []

    def add_rental(self, rental):

        if not isinstance(rental, Rental):
            raise TypeError("Invalid rental object")

        self.rentals.append(rental)

    def calculate_total_revenue(self):

        total_revenue = 0

        for rental in self.rentals:

            total_revenue += rental.calculate_rental_amount()

        return total_revenue