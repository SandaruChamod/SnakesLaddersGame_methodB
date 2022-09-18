/* Dice
 * Author: Sandaru Kalapuge
 * Creation date: 12/10/2021
 */
MACHINE
    Dice

/* Declaration of constants */
CONSTANTS
    Sides
    
/* Properties of constants */
PROPERTIES
    Sides <: NAT1 &
    Sides = 1..6
END
