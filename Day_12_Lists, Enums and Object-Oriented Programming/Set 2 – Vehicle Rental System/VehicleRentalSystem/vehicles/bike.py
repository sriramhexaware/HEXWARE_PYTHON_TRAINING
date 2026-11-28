from vehicles.vehicle import Vehicle
from enums.vehicle_type import VehicleType


class Bike(Vehicle):

    def __init__(self, registration_number, mileage):

        super().__init__(
            registration_number,
            mileage,
            VehicleType.BIKE
        )

    def daily_rate(self):
        return 800

    def late_fee(self, days):

        if days < 0:
            raise ValueError("Late days cannot be negative")

        return days * 200