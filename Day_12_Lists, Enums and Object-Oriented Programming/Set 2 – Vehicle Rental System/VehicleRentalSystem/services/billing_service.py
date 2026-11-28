class BillingService:

    def calculate_bill(self, rental):

        rental_amount = rental.calculate_rental_amount()

        return rental_amount

    def calculate_final_bill(self, rental, late_days):

        rental_amount = rental.calculate_rental_amount()

        late_fee = rental.calculate_late_fee(late_days)

        return rental_amount + late_fee