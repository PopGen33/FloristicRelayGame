# Simulate a game of floristic relay

#' Simulate the floristic relay game
#'
#' @description
#' A function to simulate a game of floristic relay. This function requires a \code{\link[=floristic_gameboard]{gameboard}},
#'  a vector of events (see param definition below), a vector of \code{\link[=floristic_interaction]{interactions}},
#'  and a list of \code{\link[=floristic_player]{players}}. The function returns a dataframe recording the results of
#'  the simulated game. If 'turn-by-turn' is set to TRUE, it prints messages detailing the game turn-by-turn (used for debug).
#'
#' @param gameboard A \code{\link[=floristic_gameboard]{floristic_gameboard}} object
#' @param event_deck A vector of character strings representing disturbance events. These MUST EXACTLY MATCH the "event" field of
#'  each \code{\link[=floristic_plant]{plant's}} \code{\link[=event_response]{event responses}}. For example, \link{momerath_herb}
#'  has an event response defined for the event "Wildfire", so it is valid to include "Wildfire" in an event_deck. See example below
#'  as a demonstration of building a full deck. If you add an event that does not exactly match the responses defined for the plants
#'  in the game, the function will fail. Once the deck is "depleted", it is cycled through in the same order.
#' @param interactions_deck A vector of \code{\link[=floristic_interaction]{floristic interactions}} that are drawn when players
#'  are on the same square at the end of a turn. Players move according to the instructions on that card. Once the deck is
#'  "depleted", it is cycled through in the same order.
#' @param player_order A list of \code{\link[=floristic_player]{players}}. Players play every turn in the same order as
#'  this list. See example below for creating a game with 6 players.
#' @param turn_by_turn Logical. Print messages describing the game being simulated turn-by-turn (useful for debugging).
#'  FALSE by default.
#' @returns A dataframe of the final rankings. It has the columns "Plant_Name", "Late_or_Early", "Final_Position", and "Rank".
#' \describe{
#'   \item{`Plant_Name`}{The name of the a \link{floristic_plant}.}
#'   \item{`Late or Early`}{The plant's "type"; either early-succession or late-succession; denoted "Early" and "Late", respectively.}
#'   \item{`Final_Position`}{The position of the plant on the \link{floristic_gameboard} at the end of the game. At least one will be >= length(gameboard@spaces).}
#'   \item{`Rank`}{The plant's rank. Rank 1 is the winner and they are enumerated from 1 to the number of total players in the game. Note that this order is determined by
#'      simply calling \code{\link[dplyr]{arrange}} on the Final_Position, so ties are not explicitly handled.}
#' }
#' @examples
#' \dontrun{
#' # Create and randomize events deck
#' # (events are drawn in this order; repeats after cycling through the deck)
#' # Can add in events of specific type here;
#' # e.g. sample(c(event_set, rep("No Disturbance", times = 6)))
#' event_deck <- c(rep("No Disturbance", times = 6),
#'                 rep("Landslide", times = 2),
#'                 rep("Animals Grazing", times = 2),
#'                 rep("Wildfire", times = 2))
#' event_deck <- sample(event_deck)
#'
#' # Create and randomize interactions deck (using pre-defined interactions)
#' # (interactions are drawn in this order; repeats after cycling through the deck)
#' interactions_deck <- c(competition_for_water,
#'                        competition_for_light,
#'                        facilitation_with_nutrients,
#'                        facilitation_with_shade,
#'                        tolerance,
#'                        tolerance)
#' interactions_deck <- sample(interactions_deck)
#'
#' # Create and randomize player list (players play their turn in this order)
#' # (uses pre-defined floristic_plants)
#' player_order <- list(
#'     floristic_player(player_character = momerath_herb,
#'                      position = 0L),
#'     floristic_player(player_character = lorax_tree,
#'                      position = 0L),
#'     floristic_player(player_character = grickle_grass,
#'                      position = 0L),
#'     floristic_player(player_character = truffula_tree,
#'                      position = 0L),
#'     floristic_player(player_character = mimsy_bush,
#'                      position = 0L),
#'     floristic_player(player_character = borogrove_grass,
#'                      position = 0L)
#' )
#' player_order <- sample(player_order)
#'
#' # simulate game
#' # (Uses the default_gameboard)
#' game_result <- simulate_floristic_game(default_gameboard,
#'                                        event_deck,
#'                                        interactions_deck,
#'                                        player_order)
#' game_result
#'}
#' @seealso \link{floristic_player}, \link{floristic_gameboard}, \link{floristic_interaction}
#' @import S7 dplyr
#' @export
simulate_floristic_game <- function(gameboard, event_deck, interactions_deck, player_order, turn_by_turn = FALSE){
    # TODO: Refactor this to make it nicer? Kind of a mess
    # Game continues until some player reaches the goal (has position equal to the length of the board)
    goal_state <- FALSE
    turn <- 0L
    interaction_deck_index <- 0L

    while(!goal_state){
        if(turn_by_turn){message(paste0("Current turn is ", turn))}
        # Draw Event Card
        current_event <- event_deck[[(turn %% length(event_deck)) + 1]]
        if(turn_by_turn){message(paste0("Current event is ", current_event))}
        # Resolve the event for each player in player_order; can't use "play in player_order" b/c that makes copies instead of referencing the original object
        for(i in 1:length(player_order)){
            if(turn_by_turn){message(paste0("\tCurrent player is ", player_order[[i]]@player_character@name," at position ", player_order[[i]]@position))}
            # Resolve Event; below is slightly horrifying, but it filters the response set to the current event and extracts the numeric response
            player_order[[i]]@position <- player_order[[i]]@position +
                Filter(function(x) x@event == current_event, player_order[[i]]@player_character@event_responses)[[1]]@response
            if(player_order[[i]]@position < 0L){
                player_order[[i]]@position <- 0L
            }
            # Resolve instant +/- effects from the board; note that this assumes it can't send player to another space with an effect
            # position 0 (start) by definition cannot have an effect (and there is no 0 index in the @spaces vector so this guards against trying to access that)
            if(!player_order[[i]]@position == 0L & player_order[[i]]@position < length(gameboard)){
                player_order[[i]]@position <- player_order[[i]]@position +
                    gameboard@spaces[player_order[[i]]@position]
                if(player_order[[i]]@position < 0L){
                    player_order[[i]]@position <- 0L
                }
            }
            if(turn_by_turn){message(paste0("\t\tPlayer moves to position ", player_order[[i]]@position, " (after any gameboard effects)"))}
        }
        if(turn_by_turn){message("Current turn ended. Checking interactions...")}
        # Check for interactions (players with same position) in player order and resolve them using interaction_deck
        for(i in 1:(length(player_order)-1)){
            for(j in (i+1):length(player_order)){
                if(player_order[[i]]@position == player_order[[j]]@position){
                    # These two players are interacting; draw from interaction_deck
                    current_interaction <- interactions_deck[[(interaction_deck_index %% length(interactions_deck)) + 1]]
                    if(turn_by_turn){message(paste0("\t", player_order[[i]]@player_character@name, " and ", player_order[[j]]@player_character@name, " are interacting via ", current_interaction@name))}
                    # determine if they're both the same "type"
                    if(player_order[[i]]@player_character@type == player_order[[j]]@player_character@type){
                        if(turn_by_turn){message(paste0("\t\tThe plants are the same type: ", player_order[[i]]@player_character@type))}
                        # Roll for if i or j is winner (winner 1, loser 2) and change their position
                        coin_flip <- sample(c(i,j))
                        winner <- coin_flip[[1]]
                        loser <- coin_flip[[2]]
                        if(turn_by_turn){message(paste0("\t\t", player_order[[winner]]@player_character@name, " wins the coin toss"))}
                        player_order[[winner]]@position <- player_order[[winner]]@position + current_interaction@tie_winner
                        player_order[[loser]]@position <- player_order[[loser]]@position + current_interaction@tie_loser
                        # set positions < 0 to 0
                        if(player_order[[winner]]@position < 0){
                            player_order[[winner]]@position <- 0L
                        }
                        if(player_order[[loser]]@position < 0){
                            player_order[[loser]]@position <- 0L
                        }
                        if(turn_by_turn){message("\t\t", player_order[[winner]]@player_character@name, " moves to position ", player_order[[winner]]@position)}
                        if(turn_by_turn){message("\t\t", player_order[[loser]]@player_character@name, " moves to position ", player_order[[loser]]@position)}
                    }else{
                        # They're not the same type; resolve according to rules starting with i
                        if(player_order[[i]]@player_character@type == "Early"){
                            player_order[[i]]@position <- player_order[[i]]@position + current_interaction@early_effect
                        }else{
                            player_order[[i]]@position <- player_order[[i]]@position + current_interaction@late_effect
                        }
                        if(player_order[[i]]@position < 0){
                            player_order[[i]]@position <- 0L
                        }
                        # Do the same thing for j
                        if(turn_by_turn){message("\t\t", player_order[[i]]@player_character@name, "(", player_order[[i]]@player_character@type, ")", " moves to position ", player_order[[i]]@position)}
                        if(player_order[[j]]@player_character@type == "Early"){
                            player_order[[j]]@position <- player_order[[j]]@position + current_interaction@early_effect
                        }else{
                            player_order[[j]]@position <- player_order[[j]]@position + current_interaction@late_effect
                        }
                        if(player_order[[j]]@position < 0){
                            player_order[[j]]@position <- 0L
                        }
                        if(turn_by_turn){message("\t\t", player_order[[j]]@player_character@name, "(", player_order[[j]]@player_character@type, ")", " moves to position ", player_order[[j]]@position)}
                    }
                    interaction_deck_index <- interaction_deck_index + 1
                }
            }
        }
        # Check if the game is over (player has position equal to or greater than length(gameboard))
        for(i in 1:length(player_order)){
            if(player_order[[i]]@position >= length(gameboard@spaces)){
                goal_state <- TRUE
                if(turn_by_turn){message(paste0(player_order[[i]]@player_character@name, " has reached the end of the gameboard. The game ends on turn ", turn))}
            }
        }
        turn <- turn + 1L
    }

    # Everything about the end state is contained in player_order
    # let's extract the data to a dataframe and order it
    final_rankings <- data.frame(character <- character(),
                                 type <- character(),
                                 final_position <- numeric())
    for(play in player_order){
        new_row <- data.frame(character <- play@player_character@name,
                              type <- play@player_character@type,
                              final_position <- play@position)
        final_rankings <- rbind(final_rankings, new_row)
    }

    # Fix names and return final rankings
    names(final_rankings) <- c("Plant_Name", "Late_or_Early", "Final_Position")
    # TODO: Figure out a way of refering to Final_Position that devtools::check() likes...
    final_rankings <- final_rankings %>% arrange(desc(Final_Position))

    # Add rank column
    final_rankings <- cbind(final_rankings, Rank = 1:length(player_order))

    return(final_rankings)
}
