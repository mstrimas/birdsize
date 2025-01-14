#' Simulate individual measurements for many populations
#'
#' For a community (i.e. a collection of populations of different species, or of the same species at different points in time or locations, etc), simulate individual-level size and metabolic rate measurements.
#'
#' @param community_data_table dataframe containing at least one of `aou`, `genus` *and* `species`, or `mean_size` and a column for species abundances
#' @param abundance_column_name character, the name of the column with species abundances. Defaults to "speciestotal".
#' @return a dataframe one row per individual, all columns from `community_data_table`, and additional columns for species attributes.
#'
#' Specifically:
#'
#' * `aou`: the AOU, if provided
#' *  `sim_species_id`: the `sim_species_id` if provided
#' * `genus`: the genus associated with the AOU if provided, or the genus if provided
#' *  `species`: the species associated with the AOU if provided, or the species if provided
#' *  `individual_mass`: the simulated body mass (in grams) for this individual
#' *  `individual_bmr`: the simulated basal metabolic rate for this individual
#' *  `mean_size`: the mean body mass for this species (i.e. the parameter used for simulation)
#' *  `sd_size`: the standard deviation of body mass for this species (i.e. the parameter used for simulation)
#' *  `abundance`: the number of individuals simulated of this species (i.e. parameter used for simulation)
#' *  `sd_method`: the method for finding the standard deviation for body mass for this species
#' @export
#' @importFrom purrr pmap_dfr
#' @importFrom dplyr mutate left_join
#'
#' @examples
#'
#' demo_community <- community_generate(demo_route_clean)
#' head(demo_community)

community_generate <- function(community_data_table, abundance_column_name = "speciestotal") {

  colnames(community_data_table) <- tolower(colnames(community_data_table))

  community_vars <- colnames(community_data_table)

  # Check that the necessary variables are provided

  contains_aou <- "aou" %in% community_vars
  contains_genus_species <- all("genus" %in% community_vars, "species" %in% community_vars)
  contains_mean <- "mean_size" %in% community_vars
  contains_abundance <- abundance_column_name %in% community_vars

  if(!contains_abundance) {
    stop("abundance column is required. If the name is not `speciestotal` specify using the `abundance_column_name` argument")
  }

  if(!(contains_aou | contains_mean | contains_genus_species)) {
    stop("At least one of `aou`, `genus` and `species`, or `mean_size` is required")
  }

  # Identify ID/grouping columns and columns to pass to sim fxns.

  community_data_table <- community_data_table %>%
    dplyr::mutate(rejoining_id = dplyr::row_number(),
                  abundance = .data[[abundance_column_name]])

  community_vars_mod <- colnames(community_data_table)

  possible_sim_vars <- c("abundance", "aou", "mean_size", "sd_size", "sim_species_id", "species", "genus")

  id_vars <- c(community_vars_mod[ which(!(community_vars_mod %in% possible_sim_vars))])

  sim_vars <- c(community_vars_mod[ which(community_vars_mod %in% possible_sim_vars)])

  # # For the cols to pass in, add NA columns for any of the variables that the sim fxns can use that aren't included
  na_vars <- possible_sim_vars[ which(!(possible_sim_vars %in% community_vars_mod))]

  na_table <- matrix(nrow = nrow(community_data_table), ncol = length(na_vars)) %>%
    as.data.frame()
  colnames(na_table) <- na_vars

  # Split into 2 tables, one with ID cols and one for the cols to pass in.
  ids_table <- community_data_table[,id_vars]

  sim_vars_table <- community_data_table[ ,sim_vars] %>%
    cbind(na_table)

  # Draw populations
  populations <- purrr::pmap_dfr(sim_vars_table,
                                 pop_generate,
                                 .id = "rejoining_id") %>%
    dplyr::mutate(rejoining_id = as.numeric(.data$rejoining_id))


  community <- suppressMessages(dplyr::left_join(ids_table, populations) %>% dplyr::select(-"rejoining_id"))

  return(community)

}

#' Clean raw Breeding Bird Survey survey data
#'
#' The raw data for the Breeding Bird Survey includes unidentified species and some species that are not well-sampled by the BBS methods. This function filters a dataframe to remove those species.
#'
#' @param bbs_survey_data data frame with columns for species and aou
#'
#' @return bbs_survey_data with unidentified species, nightbirds, waterbirds, non-targets removed
#' @export
#'
#' @examples
#'
#' filter_bbs_survey(demo_route_raw) %>%
#' head()
#'
#' @importFrom dplyr filter
filter_bbs_survey <- function(bbs_survey_data) {

  colnames(bbs_survey_data) <- tolower(colnames(bbs_survey_data))

  if(!("aou" %in% colnames(bbs_survey_data))) {
    stop("`aou` column is required!")
  }

  unidentified_species <- unidentified_species
  nontarget_species <- nontarget_species

  bbs_survey_data <- bbs_survey_data %>%
    dplyr::filter(!(.data$aou %in% unidentified_species$aou)) %>%
    dplyr::filter(!(.data$aou %in% nontarget_species$aou))

  bbs_survey_data

}


