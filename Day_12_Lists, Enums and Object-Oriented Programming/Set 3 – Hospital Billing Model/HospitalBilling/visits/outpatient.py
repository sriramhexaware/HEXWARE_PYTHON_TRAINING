from visits.visit import Visit
from enums.visit_type import VisitType


class OutPatientVisit(Visit):

    def __init__(self, patient_id, patient, doctor, department):
        super().__init__(
            patient_id, patient, doctor, department,
            VisitType.OUTPATIENT
        )

    def calculate_bill(self):
        return 500