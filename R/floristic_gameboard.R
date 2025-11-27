# Floristic Game object definitions (using S7 objects)

# Define game board
# The board is linear and the only thing read from it is
# "if you land on this square, move forward/backward x spaces"
# So, this can just be a vector of mostly zeros and positive or
# negative numbers for the spaces you need to move when you land
# on that space
floristic_gameboard <- new_class("board",
                                 properties = list(
                                     spaces = class_integer
                                 ),
                                 validator = function(self){
                                     if(self@spaces[[length(self@spaces)]] != 0){
                                         "The last space (goal) must be integer 0."
                                     }
                                 })
