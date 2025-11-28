# Define players
# Players only have two properties: player_character (plant) and position (integer;
# where they are on the board, always initialized at zero)
# A turn order is an ordered set of players

#' Define a floristic relay player
#'
#' @description
#' Players have two properties: a \code{\link[=floristic_plant]{plant}} and a position on the board. The plant is defined by a \code{\link{floristic_plant}}
#' object and the postion is an integer representing the players position on the \code{\link[=floristic_gameboard]{gameboard}}. The start postion is represented
#' by 0. The game ends on the turn when a player reaches the end of the \code{\link[=floristic_gameboard]{gameboard}}.When defining players, it's best to define a
#' list of all players in the game as in the example below. Players play their turn in the same order as this list when the game is simulated
#'
#' @param name A character string representing the name of the player. This is never read by anything in the package,
#'  but others may find a use for this property. Can be left empty and is in the example below.
#' @param player_character A \code{\link{floristic_plant}} defining how the player moves in response to disturbance events.
#' @param position An integer representing the players postion on the \code{\link[=floristic_gameboard]{gameboard}}. Should be initialized as 0 to have the player start the game at the start position.
#' @examples
#'\dontrun{
#' # the plants here have already been defined; e.g. momerath_herb is
#' # a floristic_plant defined in the floristic_plant example code
#' default_players <- list(
#'     player(player_character = momerath_herb,
#'            position = 0L),
#'     player(player_character = lorax_tree,
#'            position = 0L),
#'     player(player_character = grickle_grass,
#'            position = 0L),
#'     player(player_character = truffula_tree,
#'            position = 0L),
#'     player(player_character = mimsy_bush,
#'            position = 0L),
#'     player(player_character = borogrove_grass,
#'            position = 0L)
#' )
#'}
#' @seealso \link{floristic_plant}, \link{floristic_gameboard}
#' @import S7
#' @export
floristic_player <- new_class("floristic_player",
                              properties = list(
                                  name = class_character,
                                  player_character = floristic_plant,
                                  position = class_integer
                              ))
