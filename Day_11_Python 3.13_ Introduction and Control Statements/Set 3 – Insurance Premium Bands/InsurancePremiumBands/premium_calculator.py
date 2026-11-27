
def calculate_final_premium(
    base_premium: float,
    bmi_loading: float,
    is_smoker: bool,
    term: int
) -> float:

    smoker_loading = 20 if is_smoker else 0

    discount = 5 if term == 20 else 0

    total_loading = bmi_loading + smoker_loading

    # Multiplication and division happen before addition/subtraction.
    loading_amount = base_premium * total_loading / 100

    # Comparison is evaluated before logical AND.
    # The 5% discount applies only when term is 20.
    if term == 20 and base_premium > 0:
        discount_amount = base_premium * discount / 100
    else:
        discount_amount = 0

    final_premium = base_premium + loading_amount - discount_amount

    return final_premium
