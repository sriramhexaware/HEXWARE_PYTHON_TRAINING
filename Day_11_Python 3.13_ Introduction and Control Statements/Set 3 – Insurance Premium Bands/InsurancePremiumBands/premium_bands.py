
def get_base_premium(age: int, term: int) -> float:

    match age:

        case x if 18 <= x <= 30:
            match term:
                case 10:
                    return 5000.00
                case 20:
                    return 8000.00
                case _:
                    raise ValueError("Invalid policy term")

        case x if 31 <= x <= 45:
            match term:
                case 10:
                    return 7000.00
                case 20:
                    return 10000.00
                case _:
                    raise ValueError("Invalid policy term")

        case x if 46 <= x <= 60:
            match term:
                case 10:
                    return 10000.00
                case 20:
                    return 14000.00
                case _:
                    raise ValueError("Invalid policy term")

        case _:
            raise ValueError("Applicant is not eligible")
