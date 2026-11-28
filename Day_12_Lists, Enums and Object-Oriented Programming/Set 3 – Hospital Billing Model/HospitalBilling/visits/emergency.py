from visits.visit import Visit
from enums.visit_type import VisitType


class EmergencyVisit(Visit):

    def __init__(self, patient_id, patient, doctor, department):
        super().__init__(
            patient_id, patient, doctor, department,
            VisitType.EMERGENCY
        )

    def calculate_bill(self):
        base_charge = 1000
        surcharge = 1500

        return base_charge + surcharge