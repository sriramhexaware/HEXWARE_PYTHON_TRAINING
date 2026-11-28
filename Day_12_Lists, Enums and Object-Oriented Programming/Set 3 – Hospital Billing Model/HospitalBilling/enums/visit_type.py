from enum import Enum


class VisitType(Enum):
    OUTPATIENT = "Outpatient"
    INPATIENT = "Inpatient"
    EMERGENCY = "Emergency"