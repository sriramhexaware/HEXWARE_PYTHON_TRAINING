
def check_age(age: int) -> str:

    if age < 0:
        return "Invalid - Negative age"
    elif age < 21:
        return "Rejected - Age below 21"
    elif age > 60:
        return "Rejected - Age above 60"
    else:
        return "Eligible"


def check_income(income: float, emi: float) -> str:

    if income <= 0:
        return "Invalid - Income must be positive"
    elif emi < 0:
        return "Invalid - EMI cannot be negative"
    else:
        emi_ratio: float = (emi / income) * 100

        if emi_ratio > 40:
            return "Rejected - High EMI ratio"
        else:
            return "Eligible"



def check_credit_score(credit_score: int) -> str:

    if credit_score < 300 or credit_score > 900:
        return "Invalid - Credit score out of range"
    elif credit_score < 650:
        return "Rejected - Credit score below minimum"
    else:
        return "Valid"



def check_employment(employment: str) -> str:

    if employment == "Salaried":
        return "Preferred"
    elif employment == "Self-employed":
        return "Additional Verification"
    else:
        return "Invalid - Employment type"


def check_existing_loans(existing_loans: int) -> str:

    if existing_loans < 0:
        return "Invalid - Negative loan count"
    elif existing_loans > 2:
        return "Rejected - Existing loan limit exceeded"
    else:
        return "Eligible"


def check_eligibility(
    age: int,
    income: float,
    emi: float,
    credit_score: int,
    employment: str,
    existing_loans: int
) -> str:

    age_status: str = check_age(age)

    if age_status != "Eligible":
        return age_status

    income_status: str = check_income(income, emi)

    if income_status != "Eligible":
        return income_status

    credit_status: str = check_credit_score(credit_score)

    if credit_status != "Valid":
        return credit_status

    employment_status: str = check_employment(employment)

    if employment_status.startswith("Invalid"):
        return employment_status

    loan_status: str = check_existing_loans(existing_loans)

    if loan_status != "Eligible":
        return loan_status

    # Final decision using nested conditions
    if age_status == "Eligible":
        if income_status == "Eligible":
            if credit_status == "Valid":
                if employment_status in ("Preferred", "Additional Verification"):
                    if loan_status == "Eligible":
                        return "Approved"

    return "Rejected"
