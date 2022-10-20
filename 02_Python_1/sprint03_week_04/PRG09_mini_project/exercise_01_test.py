board = ["-"]*9
currentPlayer = "x"

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

#playing the game
while True:
    #draw the game board.
    draw()
    #get current player input.
    print("Enter a square 0-8:")
    choice = int(input())
    if board[choice] == "-":
        board[choice] = currentPlayer
        switchPlayer()
    


    #players can't chose filled squares.
    
    #switching turns.
    
    #if player chooses nonexisting square.

    #if neither x or o wins and the board is full it will result in a tie.

    #players can restart.