
def calculate_final_bill(
    electricity_charge: float,
    fixed_charge: float,
    is_late: bool,
    is_online: bool
) -> float:

    bill = electricity_charge + fixed_charge

    # Addition and comparison are evaluated before logical AND.
    # if is_late and electricity_charge + fixed_charge > 0:
    #     bill += bill * 0.10

    if is_late:
        bill += bill * 0.10

    if is_online:
        bill -= bill * 0.05

    return bill
