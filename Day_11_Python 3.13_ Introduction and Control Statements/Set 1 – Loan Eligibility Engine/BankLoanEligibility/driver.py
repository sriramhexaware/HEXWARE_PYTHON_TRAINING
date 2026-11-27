
def run_application():

    applicant_id: int = 101
    applicant_name: str = "Sriram"
    age: int = 25
    income: float = 50000.0
    emi: float = 15000.0
    credit_score: int = 780
    employment: str = "Salaried"
    existing_loans: int = 1

    print(f"Applicant ID: {applicant_id}")
    print(f"Applicant Name: {applicant_name}")
    print(f"Age: {age}")
    print(f"Monthly Income: ₹{income}")
    print(f"Monthly EMI: ₹{emi}")
    print(f"Credit Score: {credit_score}")
    print(f"Employment Type: {employment}")
    print(f"Existing Loans: {existing_loans}")

from applicant_processor import Applicant, process_applicants


def run_application():

    applicants: list[Applicant] = [

        {
            "applicant_id": 101,
            "name": "Arun",
            "age": 25,
            "income": 50000.0,
            "emi": 15000.0,
            "credit_score": 780,
            "employment": "Salaried",
            "existing_loans": 1
        },

        {
            "applicant_id": 102,
            "name": "Bala",
            "age": 30,
            "income": 0.0,
            "emi": 10000.0,
            "credit_score": 720,
            "employment": "Salaried",
            "existing_loans": 0
        },

        {
            "applicant_id": 103,
            "name": "Charan",
            "age": -5,
            "income": 40000.0,
            "emi": 10000.0,
            "credit_score": 750,
            "employment": "Salaried",
            "existing_loans": 1
        },

        {
            "applicant_id": 104,
            "name": "Deepak",
            "age": 35,
            "income": 60000.0,
            "emi": 20000.0,
            "credit_score": 950,
            "employment": "Salaried",
            "existing_loans": 1
        },

        {
            "applicant_id": 105,
            "name": "Ezhil",
            "age": 28,
            "income": 45000.0,
            "emi": 12000.0,
            "credit_score": 720,
            "employment": "Self-employed",
            "existing_loans": 2
        },

        {
            "applicant_id": 106,
            "name": "Farhan",
            "age": 40,
            "income": 80000.0,
            "emi": 20000.0,
            "credit_score": 680,
            "employment": "Salaried",
            "existing_loans": 0
        },

        {
            "applicant_id": 107,
            "name": "Gokul",
            "age": 65,
            "income": 50000.0,
            "emi": 10000.0,
            "credit_score": 800,
            "employment": "Salaried",
            "existing_loans": 1
        },

        {
            "applicant_id": 108,
            "name": "Hari",
            "age": 32,
            "income": 40000.0,
            "emi": 25000.0,
            "credit_score": 760,
            "employment": "Salaried",
            "existing_loans": 1
        },

        {
            "applicant_id": 109,
            "name": "Irfan",
            "age": 45,
            "income": 90000.0,
            "emi": 20000.0,
            "credit_score": 810,
            "employment": "Salaried",
            "existing_loans": 3
        },

        {
            "applicant_id": 110,
            "name": "Jeeva",
            "age": 29,
            "income": 50000.0,
            "emi": 10000.0,
            "credit_score": 620,
            "employment": "Salaried",
            "existing_loans": 0
        }
    ]

    print(f"\n========== BANK LOAN PRE-SCREENING ==========")

    results = process_applicants(applicants, approval_limit=3)

    print(f"\n================ DECISION TABLE ================")

    print(
        f"{'ID':<6}"
        f"{'Name':<12}"
        f"{'Score':<8}"
        f"{'Band':<12}"
        f"{'Rate':<8}"
        f"{'Decision':<40}"
    )

    print(f"-" * 86)

    for result in results:

        print(
            f"{result['applicant_id']:<6}"
            f"{result['name']:<12}"
            f"{result['credit_score']:<8}"
            f"{result['credit_band']:<12}"
            f"{result['interest_rate']:<8}"
            f"{result['decision']:<40}"
        )

    print(f"-" * 86)
    print(f"Total processed: {len(results)}")
    print(
        f"Total approved: "
        f"{sum(1 for r in results if r['decision'] == 'Approved')}"
    )
