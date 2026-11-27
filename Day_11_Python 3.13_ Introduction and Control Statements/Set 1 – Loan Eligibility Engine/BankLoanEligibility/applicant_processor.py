
from typing import TypedDict

from eligibility_rules import check_eligibility
from credit_products import get_credit_details


class Applicant(TypedDict):
    applicant_id: int
    name: str
    age: int
    income: float
    emi: float
    credit_score: int
    employment: str
    existing_loans: int


class Decision(TypedDict):
    applicant_id: int
    name: str
    credit_score: int
    credit_band: str
    interest_rate: str
    loan_product: str
    decision: str


def process_applicants(
    applicants: list[Applicant],
    approval_limit: int = 3
) -> list[Decision]:

    approval_count: int = 0
    results: list[Decision] = []

    for applicant in applicants:

        decision: str = check_eligibility(
            applicant["age"],
            applicant["income"],
            applicant["emi"],
            applicant["credit_score"],
            applicant["employment"],
            applicant["existing_loans"]
        )

        if decision.startswith("Invalid"):

            results.append({
                "applicant_id": applicant["applicant_id"],
                "name": applicant["name"],
                "credit_score": applicant["credit_score"],
                "credit_band": "N/A",
                "interest_rate": "N/A",
                "loan_product": "N/A",
                "decision": decision
            })

            continue

        credit_band, rate, product = get_credit_details(
            applicant["credit_score"]
        )

        results.append({
            "applicant_id": applicant["applicant_id"],
            "name": applicant["name"],
            "credit_score": applicant["credit_score"],
            "credit_band": credit_band,
            "interest_rate": f"{rate}%" if rate is not None else "N/A",
            "loan_product": product,
            "decision": decision
        })

        if decision == "Approved":
            approval_count += 1

        if approval_count >= approval_limit:
            print(
                f"\nDaily approval limit of "
                f"{approval_limit} reached."
            )
            break

    else:
        print(f"\nAll applicant records processed successfully.")

    return results
