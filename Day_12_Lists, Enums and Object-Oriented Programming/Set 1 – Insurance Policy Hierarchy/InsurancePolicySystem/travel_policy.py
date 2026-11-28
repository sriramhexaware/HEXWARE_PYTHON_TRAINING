from policy import Policy


class TravelPolicy(Policy):

    def __init__(self, policy_number, holder_name, status,
                 travel_days, risk_factor):

        super().__init__(policy_number, holder_name, status)

        self.travel_days = travel_days
        self.risk_factor = risk_factor

    def calculate_premium(self):

        premium = (self.travel_days * 150) + (self.risk_factor * 1000)

        return premium