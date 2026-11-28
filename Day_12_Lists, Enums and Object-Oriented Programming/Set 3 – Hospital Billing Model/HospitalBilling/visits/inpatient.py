from visits.visit import Visit
from enums.visit_type import VisitType


class InPatientVisit(Visit):

    def __init__(self, patient_id, patient, doctor, department, days):
        super().__init__(
            patient_id, patient, doctor, department,
            VisitType.INPATIENT
        )

        if days <= 0:
            raise ValueError("Days must be positive")

        self.days = days

    def calculate_bill(self):
        return self.days * 2000