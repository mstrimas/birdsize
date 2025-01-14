% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summary_functions.R
\name{community_summarize}
\alias{community_summarize}
\title{Compute grouped summary statistics for a community}
\usage{
community_summarize(
  community,
  level = c("year", "species", "species_and_year", "custom"),
  id_vars = NULL
)
}
\arguments{
\item{community}{a dataframe with one row per individual, columns for \code{individual_mass} and \code{individual_bmr}, and any additional relevant grouping columns. For example, the output of \link{community_generate}.}

\item{level}{a character string specifying whether to group according to "year", "species", "species_and_year", or "custom". To use "custom", specify the grouping variables using \code{id_vars}}

\item{id_vars}{a vector of column names to group by (if using \code{level = "custom"})}
}
\value{
a dataframe with the total, mean, and standard deviation of body mass and metabolic rate summarized over the individuals in \code{community}, grouped according to the grouping variables.
}
\description{
Calculate summary statistics (total, mean, and standard deviation for abundance, biomass, and metabolic rate) for a community, with flexible grouping options.
}
\details{
For a dataframe of individuals from either numerous populations (of different species, or of the same species at different points in time), calculate summary statistics for each population or timestep, or for a different set of custom-specified grouping variables.
}
\examples{
bbs_route <- demo_route_raw \%>\% filter_bbs_survey()
community_data <- community_generate(bbs_route)
community_summarize(community_data)

}
