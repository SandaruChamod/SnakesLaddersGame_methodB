/* Game
 * Author: Sandaru Kalapuge
 * Creation date: 12/10/2021
 */
MACHINE
    Game
    
DEFINITIONS
    /* Responsible for check whether the given index is the wining square index */
    isTheWinningSquare(squareIndex) == (squareIndex = WinningSquare);
    
    /* Responsible for check whether the given square index has a snake */
    isASnakeSquare(squareIndex) == (squareIndex : dom(Snakes));
    
    /* Responsible for check whether the given square index has a ladder */
    isALadderSquare(squareIndex) == (squareIndex : dom(Ladders))
   
/* Include both Board & Dice machines */
INCLUDES
    Board, Dice
    
/* Sets */
SETS
    GAME_STATUSES = {WON, ON_GOING};
    MOVEMENT_STATUSES = {GO_DOWN_A_SNAKE, GO_UP_A_LADDER, TOO_HIGH_TO_FINISH, FINISHED_AND_WON, LANDED_ON_A_NORMAL_SQUARE};
    NOTIFICATIONS = {NEW_GAME_STARTED}
    
/* Variable declaration */
VARIABLES
    currentStatus,
    currentLocation,
    numberOfMoves,
    numberOfSnakesGoneDown,
    numberOfLaddersGoneUp,
    visitedSquares,
    lastThrownDiceValue
    
/* Variable definition */
INVARIANT
    currentStatus <: GAME_STATUSES &
    currentLocation : NAT &
    numberOfMoves : NAT &
    numberOfSnakesGoneDown : NAT &
    numberOfLaddersGoneUp : NAT &
    lastThrownDiceValue : NAT &
    visitedSquares : seq(NAT1)
    
/* Variable initialization */
INITIALISATION
    currentStatus := {ON_GOING} ||
    currentLocation := 0 ||
    numberOfMoves := 0 ||
    numberOfSnakesGoneDown := 0 ||
    numberOfLaddersGoneUp := 0 ||
    lastThrownDiceValue := 0 ||
    visitedSquares := []
    
OPERATIONS
    
    /* Responsible for move the token to given position */
    movementStatus, squareIndex <-- Move(diceValue) = 
        PRE
            movementStatus :  MOVEMENT_STATUSES & diceValue : NAT1 & diceValue : Sides & ON_GOING : currentStatus
        THEN
            /* Update the last thrown dice value */
            lastThrownDiceValue := diceValue ||
            
            /* Check whether the current position is greater than the finishing position */
            IF ((currentLocation + diceValue) > WinningSquare)
            THEN
                movementStatus := TOO_HIGH_TO_FINISH ||
                squareIndex := currentLocation
            /* Check whether the current position is the winning position */            
            ELSIF (isTheWinningSquare(currentLocation + diceValue))
            THEN
                currentLocation := currentLocation + diceValue ||
                movementStatus := FINISHED_AND_WON ||
                squareIndex := currentLocation + diceValue ||
                visitedSquares := visitedSquares <- (currentLocation + diceValue) ||
                numberOfMoves := succ(numberOfMoves) ||
                currentStatus := {WON}
            /* Check whether the current position has a snake */ 
            ELSIF (isASnakeSquare(currentLocation + diceValue))
            THEN
                currentLocation := Snakes(currentLocation + diceValue) ||
                movementStatus := GO_DOWN_A_SNAKE ||
                squareIndex := Snakes(currentLocation + diceValue) ||
                visitedSquares := visitedSquares ^ [(currentLocation + diceValue) , Snakes(currentLocation + diceValue)] ||
                numberOfMoves := succ(numberOfMoves) ||
                numberOfSnakesGoneDown := succ(numberOfSnakesGoneDown)
            /* Check whether the current position has a ladder */
            ELSIF (isALadderSquare(currentLocation + diceValue))
            THEN
                currentLocation := Ladders(currentLocation + diceValue) ||
                movementStatus := GO_UP_A_LADDER ||
                squareIndex := Ladders(currentLocation + diceValue) ||
                visitedSquares := visitedSquares ^ [(currentLocation + diceValue) , Ladders(currentLocation + diceValue)] ||
                numberOfMoves := succ(numberOfMoves) ||
                numberOfLaddersGoneUp := succ(numberOfLaddersGoneUp)
            /* Perform a normal square landing */
            ELSE
                currentLocation := currentLocation + diceValue ||
                movementStatus := LANDED_ON_A_NORMAL_SQUARE ||
                squareIndex := currentLocation + diceValue ||
                visitedSquares := visitedSquares <- (currentLocation + diceValue) ||
                numberOfMoves := succ(numberOfMoves)
            END
        END;
        
     /* Responsible for provide visited squares */
    squares <-- VisitedSquares = 
        BEGIN
            squares := ran(visitedSquares)
    END;    
    
    /* Responsible for start a new game */
    notification <-- NewGame =
        PRE
            notification : NOTIFICATIONS & ON_GOING /: currentStatus
        THEN
            currentLocation := 0 ||
            visitedSquares := [] ||
            numberOfMoves := 0 ||
            numberOfSnakesGoneDown := 0 ||
            numberOfLaddersGoneUp := 0 ||
            currentStatus := {ON_GOING} ||
            notification := NEW_GAME_STARTED
    END;
    
    /* Responsible for provide the current status of the game */
    currentPosition, numberOfSnakesEncountered, numberOfLaddersEncountered, numberOfTurns <-- GameStatistics = 
        BEGIN
            currentPosition := currentLocation ||
            numberOfSnakesEncountered := numberOfSnakesGoneDown ||
            numberOfLaddersEncountered := numberOfLaddersGoneUp ||
            numberOfTurns := numberOfMoves
    END
    
END
