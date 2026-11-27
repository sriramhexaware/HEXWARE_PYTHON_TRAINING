
from credit_products import get_credit_details

applicants: list[int] = [780, 720, 680, 620, 950]

for score in applicants:

    band, rate, product = get_credit_details(score)

    print(f"Credit Score: {score}")
    print(f"Credit Band: {band}")
    print(f"Interest Rate: {rate if rate is not None else 'N/A'}")
    print(f"Loan Product: {product}")
    print("-" * 35)
