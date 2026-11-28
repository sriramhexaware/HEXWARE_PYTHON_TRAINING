from policy import Policy


class MotorPolicy(Policy):

    def __init__(self, policy_number, holder_name, status,
                 vehicle_value, vehicle_age):

        super().__init__(policy_number, holder_name, status)

        self.vehicle_value = vehicle_value
        self.vehicle_age = vehicle_age

    def calculate_premium(self):

        premium = (self.vehicle_value * 0.03) + (self.vehicle_age * 500)

        return premium