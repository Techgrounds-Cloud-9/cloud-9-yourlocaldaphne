
number_list = [5,10,15,20,25]

for i in range(len(number_list)):
    current = number_list[i]

    if i == len(number_list) - 1:
        first = number_list[0]
        print(current + first)
    else:
        next = number_list[i + 1]
        print(current + next)

