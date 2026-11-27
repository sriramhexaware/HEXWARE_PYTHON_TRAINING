
applicants = [
    {"name": "Ram", "age": 25, "weight": 70, "height": 1.75, "smoker": False, "term": 10},
    {"name": "Sam", "age": 35, "weight": 85, "height": 1.80, "smoker": True, "term": 20},
    {"name": "John", "age": 45, "weight": 90, "height": 1.70, "smoker": False, "term": 10},
    {"name": "David", "age": 55, "weight": 95, "height": 1.75, "smoker": True, "term": 20},
    {"name": "Arun", "age": 28, "weight": 60, "height": 1.65, "smoker": False, "term": 20},
    {"name": "Kiran", "age": 40, "weight": 80, "height": 1.72, "smoker": True, "term": 10},
    {"name": "Raj", "age": 50, "weight": 75, "height": 1.68, "smoker": False, "term": 20},
    {"name": "Hari", "age": 30, "weight": 68, "height": 1.70, "smoker": True, "term": 10}
]


def validate_applicants(applicant_list):

    for applicant in applicant_list:

        if not (18 <= applicant["age"] <= 60):
            print(f"{applicant['name']} is ineligible: Invalid age.")
            break

        elif applicant["term"] not in (10, 20):
            print(f"{applicant['name']} is ineligible: Invalid policy term.")
            break

        print(f"{applicant['name']} : Valid")

    else:
        print("\nAll applicants passed batch validation.")
        return True

    return False
