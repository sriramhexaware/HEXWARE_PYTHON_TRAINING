
def get_fixed_charge(category: str) -> float:

    match category.lower():

        case "domestic":
            return 100.00

        case "commercial":
            return 300.00

        case "industrial":
            return 500.00

        case _:
            return 0.00
