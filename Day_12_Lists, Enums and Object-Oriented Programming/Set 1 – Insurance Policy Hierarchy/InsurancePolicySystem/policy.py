from abc import ABC, abstractmethod
from policy_status import PolicyStatus


class Policy(ABC):

    def __init__(self, policy_number, holder_name, status):
        self.policy_number = policy_number
        self.holder_name = holder_name
        self.status = status

    @property
    def policy_number(self):
        return self.__policy_number

    @policy_number.setter
    def policy_number(self, value):

        if not isinstance(value, str) or not value.strip():
            raise ValueError("Policy number cannot be empty")

        self.__policy_number = value

    @abstractmethod
    def calculate_premium(self):
        pass