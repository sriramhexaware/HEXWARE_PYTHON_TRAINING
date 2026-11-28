from abc import ABC, abstractmethod
from enums.vehicle_type import VehicleType


class Vehicle(ABC):

    def __init__(self, registration_number, mileage, vehicle_type):

        self.registration_number = registration_number
        self.mileage = mileage
        self.vehicle_type = vehicle_type

    @property
    def registration_number(self):
        return self.__registration_number

    @registration_number.setter
    def registration_number(self, value):

        if not isinstance(value, str) or not value.strip():
            raise ValueError("Registration number cannot be empty")

        self.__registration_number = value

    @property
    def mileage(self):
        return self.__mileage

    @mileage.setter
    def mileage(self, value):

        if not isinstance(value, (int, float)) or isinstance(value, bool) or value < 0:
            raise ValueError("Mileage must be a non-negative number")

        self.__mileage = value

    @abstractmethod
    def daily_rate(self):
        pass

    @abstractmethod
    def late_fee(self, days):
        pass