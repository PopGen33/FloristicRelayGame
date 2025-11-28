# Define event response first; has two properties: Event and Response

#' Define a floristic relay plant's event response
#'
#' @description
#' When an event card is drawn, a \code{\link[=floristic_plant]{plant}} responds to it by moving on the board. Every \code{\link[=floristic_plant]{plant}}
#' should have an event response defined for every event in the event deck. These are exclusively used
#' when defining \code{\link[=floristic_plant]{plant}}, so see that page for examples.
#'
#' @param event A character string representing the name of the event. This should EXACTLY MATCH the name of an event in the event deck
#' @param response An integer representing how many spaces the plant moves in response to the event (can be positive or negative).
#' @returns An event_response object.
#' @seealso \link{floristic_plant}
#' @import S7
#' @export
event_response <- new_class("event_response",
                            properties = list(
                                event = class_character,
                                response = class_integer
                            ))
