board = ["-"]*9
cross = "x"
circle = "o"

def draw():
    counter = 0
    for square in board:
        print(square, end = "")
        counter = counter + 1
        if counter % 3 == 0:
            print()


draw() 