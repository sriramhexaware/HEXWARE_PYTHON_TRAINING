
def calculate_slab_bill(units: float) -> float:

    if units <= 100:
        bill = units * 2.50

    elif units <= 200:
        bill = (100 * 2.50) + ((units - 100) * 4.00)

    elif units <= 400:
        bill = (100 * 2.50) + (100 * 4.00) + ((units - 200) * 5.50)

    else:
        bill = (100 * 2.50) + (100 * 4.00) + (200 * 5.50) + ((units - 400) * 7.00)

    return bill
