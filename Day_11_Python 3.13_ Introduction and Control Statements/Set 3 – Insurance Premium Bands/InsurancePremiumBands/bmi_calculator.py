
def calculate_bmi(weight: float, height: float):

    if weight <= 0 or height <= 0:
        raise ValueError("Weight and height must be positive.")

    bmi = weight / (height ** 2)

    if bmi < 18.5:
        category = "Underweight"
        loading = 10

    else:
        if bmi < 25:
            category = "Normal"
            loading = 0

        else:
            if bmi < 30:
                category = "Overweight"
                loading = 15

            else:
                category = "Obese"
                loading = 30

    return bmi, category, loading
