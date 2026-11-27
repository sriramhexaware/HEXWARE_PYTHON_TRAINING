
def get_credit_band(credit_score: int) -> str:

    if 750 <= credit_score <= 900:
        return "Excellent"
    elif 700 <= credit_score <= 749:
        return "Good"
    elif 650 <= credit_score <= 699:
        return "Average"
    elif 300 <= credit_score <= 649:
        return "Poor"
    else:
        return "Invalid"


def get_loan_product(credit_band: str) -> tuple[float | None, str]:

    match credit_band:

        case "Excellent":
            return 8.0, "Premium Loan"

        case "Good":
            return 10.0, "Standard Loan"

        case "Average":
            return 12.0, "Basic Loan"

        case "Poor":
            return None, "Not Eligible"

        case _:
            return None, "Invalid Credit Score"


def get_credit_details(credit_score: int) -> tuple[str, float | None, str]:

    credit_band: str = get_credit_band(credit_score)

    interest_rate: float | None
    loan_product: str

    interest_rate, loan_product = get_loan_product(credit_band)

    return credit_band, interest_rate, loan_product
