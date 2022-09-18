/* Board
 * Author: Sandaru Kalapuge
 * Creation date: 12/10/2021
 */
MACHINE
    Board
    
/* Declaration of constants */
CONSTANTS
    Squares,
    Snakes,
    Ladders,
    WinningSquare

/* Properties of constants */
PROPERTIES
    Squares <: NAT1 &
    Squares = 1..100 &
    
    Snakes : Squares <-> Squares &
    Snakes = {(31 |-> 4),(16 |-> 13),(47 |-> 25),(66 |-> 52),(63 |-> 60),(97 |-> 75)} &
    
    Ladders : Squares <-> Squares &
    Ladders = {(3 |-> 39),(27 |-> 53),(10 |-> 12),(56 |-> 84),(61 |-> 99),(72 |-> 90)} &
    
    WinningSquare : Squares &
    WinningSquare = 100
END
