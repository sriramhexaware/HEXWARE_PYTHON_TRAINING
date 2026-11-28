from models.patient import Patient
from models.doctor import Doctor

from visits.outpatient import OutPatientVisit
from visits.inpatient import InPatientVisit
from visits.emergency import EmergencyVisit

from services.billing_service import BillingService


if __name__ == "__main__":

    # Create patients
    patient1 = Patient("P101", "Arun", 25)
    patient2 = Patient("P102", "Kumar", 40)
    patient3 = Patient("P103", "Sriram", 22)

    # Create doctors
    doctor1 = Doctor("D101", "Dr. Ravi", "Cardiology")
    doctor2 = Doctor("D102", "Dr. Priya", "Neurology")
    doctor3 = Doctor("D103", "Dr. Kumar", "Emergency")

    # Create visits
    visit1 = OutPatientVisit(
        patient1.patient_id, patient1, doctor1, "Cardiology"
    )

    visit2 = InPatientVisit(
        patient2.patient_id, patient2, doctor2, "Neurology", 3
    )

    visit3 = EmergencyVisit(
        patient3.patient_id, patient3, doctor3, "Emergency"
    )

    # Create billing service
    billing = BillingService()

    # Store visits
    billing.add_visit(visit1)
    billing.add_visit(visit2)
    billing.add_visit(visit3)

    # Generate bill summary
    billing.generate_bill_summary()

    # Department-wise monthly totals
    monthly_totals = [
        ["Cardiology", [25000, 30000, 28000]],
        ["Neurology", [18000, 22000, 20000]],
        ["Orthopedics", [15000, 17000, 19000]]
    ]

    billing.display_monthly_totals(monthly_totals)