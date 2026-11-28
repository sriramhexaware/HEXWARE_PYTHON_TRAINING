from motor_policy import MotorPolicy
from health_policy import HealthPolicy
from travel_policy import TravelPolicy
from policy_status import PolicyStatus
from home_policy import HomePolicy

policies = [

    MotorPolicy("M101", "Sriram", PolicyStatus.ACTIVE, 800000, 3),
    MotorPolicy("M102", "Arun", PolicyStatus.ACTIVE, 600000, 2),
    MotorPolicy("M103", "Kavin", PolicyStatus.LAPSED, 900000, 4),

    HealthPolicy("H101", "Rahul", PolicyStatus.ACTIVE, 500000, 25),
    HealthPolicy("H102", "Priya", PolicyStatus.DRAFT, 700000, 30),
    HealthPolicy("H103", "Divya", PolicyStatus.ACTIVE, 1000000, 40),

    TravelPolicy("T101", "Kumar", PolicyStatus.ACTIVE, 10, 2),
    TravelPolicy("T102", "Vijay", PolicyStatus.CANCELLED, 15, 3),

    HomePolicy("HM101", "Sriram", PolicyStatus.ACTIVE, 5000000, 5)

]


print("=" * 75)
print("                 INSURANCE PREMIUM REPORT")
print("=" * 75)

print(f"{'Policy No':<12}{'Holder':<12}{'Type':<15}{'Status':<12}{'Premium':>12}")
print("-" * 75)

for policy in policies:

    print(
        f"{policy.policy_number:<12}"
        f"{policy.holder_name:<12}"
        f"{type(policy).__name__:<15}"
        f"{policy.status.value:<12}"
        f"{policy.calculate_premium():>12.2f}"
    )

print("=" * 75)