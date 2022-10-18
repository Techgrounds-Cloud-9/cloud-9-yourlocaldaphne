
number = 100

while True:
    number = int(input("Please enter a number:"))

    if number < 100:
        print(number, "is too low. Try again.")

    elif number == 100:
        print("100 is a good number. Very nice.")
        break

    else:
        print(number, "is too big. Try again.")





