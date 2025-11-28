# Define interactions
# Interactions have 5 properties: name, late_effect, early_effect, tie_winner, and tie_loser
# The interaction deck is ordered set of these

#' Define a floristic relay interaction
#'
#' @description
#' These cards are drawn when players
#' land on the same space at the end of a turn. Even when more than two players are on the same square
#' at the same time, interactions are resolved pairwise. Interactions between players of
#' different types (early and late) are resolved according to the "early_effect" and "late_effect"
#' fields of the card. These fields are integer values that represent the number of
#' spaces the early-type and late-type character move (positive or negative). If both players
#' are of the same type, the "winner" of the interaction is determined randomly (e.g. a coin flip)
#' and the "tie_winner" effect is given to that player and the "tie_loser" effect is applied to
#' the other player in the pair.
#'
#' @param name A character string representing the name of the interaction.
#' @param early_effect An integer representing how many spaces the "early" character-type moves in an interaction between characters of different types.
#' @param late_effect An integer representing how many spaces the "late" character-type moves in an interaction between characters of different types.
#' @param tie_winner An integer representing how many spaces the randomly-determined "winner" moves in an interaction between characters of the same type.
#' @param tie_loser An integer representing how many spaces the randomly-determined "loser" moves in an interaction between characters of the same type.
#' @returns A floristic_interaction object.
#' @examples
#'\dontrun{
#' comp_for_water <- floristic_interaction(name = "Competition for Water",
#'                                        early_effect = -1L,
#'                                        late_effect = 2L,
#'                                        tie_winner = 2L,
#'                                        tie_loser = -1L)
#'}
#' @import S7
#' @export
floristic_interaction <- new_class("floristic_interaction",
                                   properties = list(
                                       name = class_character,
                                       early_effect = class_integer,
                                       late_effect = class_integer,
                                       tie_winner = class_integer,
                                       tie_loser = class_integer
                                   ))
