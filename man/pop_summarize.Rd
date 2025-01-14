% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summary_functions.R
\name{pop_summarize}
\alias{pop_summarize}
\title{Calculate population-level summary statistics}
\usage{
pop_summarize(population)
}
\arguments{
\item{population}{a dataframe with one row per individual, and columns for \code{individual_mass} and \code{individual_bmr}, of the type produced by \link{pop_generate}.}
}
\value{
a dataframe of summary metrics (see above) for this population
}
\description{
For a population (collection of individuals), calculate the total, mean, and standard deviation of abundance, biomass, and metabolic rate.
}
\details{
For summary statistics grouped by species, year, or other variables, see \link{community_summarize}.
}
\examples{
a_population <- pop_generate(10, mean_size= 20)
pop_summarize(a_population)
}
