from vehicles.vehicle import Vehicle
from enums.vehicle_type import VehicleType


class Car(Vehicle):

    def __init__(self, registration_number, mileage):

        super().__init__(
            registration_number,
            mileage,
            VehicleType.CAR
        )

    def daily_rate(self):
        return 2000

    def late_fee(self, days):
        if days < 0:
            raise ValueError("Late days cannot be negative")

        return days * 500