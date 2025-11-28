# Define game board
# The board is linear and the only thing read from it is
# "if you land on this square, move forward/backward x spaces"
# So, this can just be a vector of mostly zeros and positive or
# negative numbers for the spaces you need to move when you land
# on that space

#' Define floristic relay game board.
#'
#' @description
#' The board is linear and composed of spaces. These spaces have
#' integer values: most spaces are 0 (no effect), positive (e.g. 1 sends the player that
#' lands there forward one space), and negative (e.g. -2 sends the player that lands there
#' backward 2 spaces). The final space is the goal space and must be 0. The start space
#' is not included in this definition and is always implicitly 0.
#'
#' @param spaces A vector of integer numbers representing the gameboard.
#' @returns A floristic_gameboard object.
#' @examples
#'\dontrun{
#' default_gameboard <- floristic_gameboard(spaces = as.integer(c(0, 0, 0, 2, 0,
#'                                                                0, 0, -1, 0, 0,
#'                                                                0, 0, -1, 0, 0,
#'                                                                -1, 0, 0, 0, 2,
#'                                                                0, 0, -1, 0, 0)))
#'}
#' @import S7
#' @export
floristic_gameboard <- new_class("floristic_gameboard",
                                 properties = list(
                                     spaces = class_integer
                                 ),
                                 validator = function(self){
                                     if(self@spaces[[length(self@spaces)]] != 0){
                                         "The last space (goal) must be integer 0."
                                     }
                                 })
