from abc import ABC, abstractmethod
from enums.visit_type import VisitType


class Visit(ABC):

    def __init__(self, patient_id, patient, doctor, department, visit_type):

        self.__patient_id = patient_id
        self.patient = patient
        self.doctor = doctor
        self.department = department
        self.visit_type = visit_type

    @property
    def patient_id(self):
        return self.__patient_id

    @abstractmethod
    def calculate_bill(self):
        pass