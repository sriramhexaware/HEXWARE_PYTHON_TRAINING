
from bmi_calculator import calculate_bmi
from premium_bands import get_base_premium
from premium_calculator import calculate_final_premium
from applicant_processor import applicants, validate_applicants


def process_applicant(applicant):

    bmi, category, bmi_loading = calculate_bmi(
        applicant["weight"],
        applicant["height"]
    )

    base_premium = get_base_premium(
        applicant["age"],
        applicant["term"]
    )

    final_premium = calculate_final_premium(
        base_premium,
        bmi_loading,
        applicant["smoker"],
        applicant["term"]
    )

    print("-" * 75)
    print(f"Applicant       : {applicant['name']}")
    print(f"Age             : {applicant['age']}")
    print(f"BMI             : {bmi:.2f}")
    print(f"BMI Category    : {category}")
    print(f"BMI Loading     : {bmi_loading}%")
    print(f"Smoker          : {'Yes' if applicant['smoker'] else 'No'}")
    print(f"Policy Term     : {applicant['term']} years")
    print(f"Base Premium    : ₹{base_premium:.2f}")
    print(f"Final Premium   : ₹{final_premium:.2f}")


if __name__ == "__main__":

    print("=" * 75)
    print("             INSURANCE PREMIUM CALCULATOR")
    print("=" * 75)

    if validate_applicants(applicants):

        print("\n========== APPLICANT PREMIUM DETAILS ==========")

        for applicant in applicants:
            process_applicant(applicant)

        print("-" * 75)
        print("\nAll eight applicants processed successfully.")
