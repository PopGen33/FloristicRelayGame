# Define the plant class

#' Define a floristic relay plant
#'
#' @description
#' These cards represent plants and determine how players move in response to events. Every player has
#' 1 plant card that determines how they play. Every plant has a type that must be EXACTLY either "Early"
#' or "Late" representing whether it is an early-succession species or a late-succession species. Plants
#' also have \code{\link[=event_response]{event responses}} that determine how players move in response to different disturbance events.
#'
#' @param name A character string representing the name of the plant.
#' @param type A character string defining whether the plant is an early or late succession species. MUST be either "Early" or "Late"
#' @param event_responses A list of \code{\link[=event_response]{event responses}} that determines how players move in response to different events.
#'  The event field must EXACTLY match the name of an event in the event deck. The response field determines how many spaces the player moves in response to that event.
#' @returns A floristic_plant object.
#' @examples
#'\dontrun{
#' momerath_herb <- floristic_plant(name = "Momerath herb",
#'                                  type = "Early",
#'                                  event_responses = list(
#'                                      event_response(event = "Wildfire",
#'                                                     response = 5L),
#'                                      event_response(event = "Landslide",
#'                                                     response = 2L),
#'                                      event_response(event = "Animals Grazing",
#'                                                     response = 0L),
#'                                      event_response(event = "No Disturbance",
#'                                                     response = -1L)
#'                                  )
#' )
#'}
#' @seealso \link{event_response}
#' @import S7
#' @export
floristic_plant <- new_class("floristic_plant",
                             properties = list(
                                 name = class_character,
                                 type = class_character, # This should maybe be a new class rather than using a string
                                 event_responses = class_list
                             ),
                             validator = function(self){
                                 if(!self@type %in% c("Early", "Late")){
                                     "@type must be either 'Early' or 'Late'"
                                 }
                                 # TODO: Find a way to validate list is of event_response or otherwise require that (or store this differently...)
                             })
