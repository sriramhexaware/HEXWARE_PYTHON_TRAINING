from vehicles.vehicle import Vehicle
from enums.vehicle_type import VehicleType


class Van(Vehicle):

    def __init__(self, registration_number, mileage):

        super().__init__(
            registration_number,
            mileage,
            VehicleType.VAN
        )

    def daily_rate(self):
        return 3500

    def late_fee(self, days):

        if days < 0:
            raise ValueError("Late days cannot be negative")

        return days * 800