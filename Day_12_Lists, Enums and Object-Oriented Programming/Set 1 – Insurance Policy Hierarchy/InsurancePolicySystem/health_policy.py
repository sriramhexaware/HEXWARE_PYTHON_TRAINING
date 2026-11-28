from policy import Policy


class HealthPolicy(Policy):

    def __init__(self, policy_number, holder_name, status,
                 coverage_amount, age):

        super().__init__(policy_number, holder_name, status)

        self.coverage_amount = coverage_amount
        self.age = age

    def calculate_premium(self):

        premium = (self.coverage_amount * 0.02) + (self.age * 100)

        return premium