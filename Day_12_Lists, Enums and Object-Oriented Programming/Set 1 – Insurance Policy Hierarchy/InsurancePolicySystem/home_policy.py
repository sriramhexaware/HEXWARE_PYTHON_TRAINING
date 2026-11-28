from policy import Policy


class HomePolicy(Policy):

    def __init__(self, policy_number, holder_name, status,
                 property_value, property_age):

        super().__init__(policy_number, holder_name, status)

        self.property_value = property_value
        self.property_age = property_age

    def calculate_premium(self):

        premium = (self.property_value * 0.01) + (self.property_age * 300)

        return premium