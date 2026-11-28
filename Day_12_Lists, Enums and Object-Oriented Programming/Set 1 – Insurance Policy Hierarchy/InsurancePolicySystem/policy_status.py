from enum import Enum

class PolicyStatus(Enum):
    DRAFT = "Draft"
    ACTIVE = "Active"
    LAPSED = "Lapsed"
    CANCELLED = "Cancelled"
