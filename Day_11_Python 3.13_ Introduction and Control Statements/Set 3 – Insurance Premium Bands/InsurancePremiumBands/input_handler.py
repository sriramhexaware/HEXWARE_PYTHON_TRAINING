
def get_integer_input(prompt: str) -> int:

    while True:

        value = input(prompt).strip()

        try:
            number = int(value)
            return number

        except ValueError:
            if value == "":
                print("Error: Input cannot be empty.")

            else:
                print("Error: Please enter a valid integer.")
