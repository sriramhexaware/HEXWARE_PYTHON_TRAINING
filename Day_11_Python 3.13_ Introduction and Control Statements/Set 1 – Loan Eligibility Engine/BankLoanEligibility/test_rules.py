
from eligibility_rules import check_eligibility

result: str = check_eligibility(
    age=25,
    income=50000.0,
    emi=15000.0,
    credit_score=780,
    employment="Salaried",
    existing_loans=1
)

print(f"Loan Decision: {result}")
