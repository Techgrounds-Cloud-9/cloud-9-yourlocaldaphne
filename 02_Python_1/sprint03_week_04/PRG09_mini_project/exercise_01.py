board = ["-"]*9
currentPlayer = "x"
print("Welcome to TICTACTOE\nRules:\n-First player to get 3 marks in a row is the winner.\n-When 9 of the squares are full the game is over. \n-If no players has 3 marks in a row the game ends in a tie.\n-Enter r to restart.\n\nPlayer x will start their turn. ")

#game board.
def draw():
    counter = 0
    for square in board:
        #if squares show 3 next to each other, it creates a new line.
        print(square, end = "")
        counter = counter + 1
        if counter % 3 == 0:
            print()
        
        
#switching turns.
def switchPlayer():
    global currentPlayer
    if currentPlayer == "x":
        currentPlayer = "o"
    else:
        currentPlayer = "x"


#showing the players who's turn it is
def whoTurn():
    if currentPlayer == "x":
        print("It is x's turn.")
    else:
        print("It is o's turn.")


#playing the game
while True:
    #draw the game board.
    draw()
    #get current player input.
    print("Enter a square 0-8:")
    try:
        user_input = input()
        if user_input == 'r':
            print("Byeeeee!")
            exit()
        choice = int(user_input)
        #players can't choose numbers less than 0 or bigger than 8.
        if choice > 8:
            print("Your number is too big. Please enter a valid square 0-8.")
            continue
        if choice < 0:
            print("Your number is too small. Please enter a valid square 0-8.")
            continue
    #players can't enter letters.
    except ValueError:
        print("You didn't enter a number. Please enter a valid square 0-8.")

    #players can't chose filled squares.
    if board[choice] == "-":
        board[choice] = currentPlayer
        switchPlayer()
        whoTurn()
    else:
        print("This square is already occupied. Try again.")