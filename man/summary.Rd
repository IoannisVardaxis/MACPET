% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summary-methods.R
\docType{methods}
\name{summary}
\alias{summary}
\alias{summary.PSelf}
\alias{summary,PSelf-method}
\alias{summary,PSelf,summary-method}
\alias{summary.PSFit}
\alias{summary,PSFit-method}
\alias{summary,PSFit,summary-method}
\alias{summary.PIntra}
\alias{summary,PIntra-method}
\alias{summary,PIntra,summary-method}
\alias{summary.PInter}
\alias{summary,PInter-method}
\alias{summary,PInter,summary-method}
\alias{summary.GenomeMap}
\alias{summary,GenomeMap-method}
\alias{summary,GenomeMap,summary-method}
\title{summary methods for the MACPET classes.}
\usage{
\method{summary}{PSelf}(object, ...)

\S4method{summary}{PSelf}(object, ...)

\method{summary}{PSFit}(object, threshold = NULL, ...)

\S4method{summary}{PSFit}(object, threshold = NULL, ...)

\method{summary}{PIntra}(object, heatmap = FALSE, ...)

\S4method{summary}{PIntra}(object, heatmap = FALSE, ...)

\method{summary}{PInter}(object, heatmap = FALSE, ...)

\S4method{summary}{PInter}(object, heatmap = FALSE, ...)

\method{summary}{GenomeMap}(object, threshold = NULL, ...)

\S4method{summary}{GenomeMap}(object, threshold = NULL, ...)
}
\arguments{
\item{object}{An object of correct class used to create different summaries.}

\item{...}{Further arguments to be passed to the summary function.}

\item{threshold}{A numeric representing the FDR cut-off or summarizing
singificant peaks (or interactions), if NULL the summary is based on all the peaks found.}

\item{heatmap}{TRUE or FALSE indicating whether the user wants to plot a
heat-map plot for the Intra/Inter-chromosomal PET counts within chromosomes or
 between different chromosomes.}
}
\value{
A summary of the \code{object} and a heat-map plot depending on the
class of the input.
}
\description{
Different summary methods for the classes in the
\code{\link{MACPET}} package.
}
\examples{

#load Self-ligated data: (class=PSelf)
load(system.file('extdata', 'MACPET_pselfData.rda', package = 'MACPET'))
class(MACPET_pselfData)
summary(MACPET_pselfData)

#load Self-ligated data: (class=PSFit)
load(system.file('extdata', 'MACPET_psfitData.rda', package = 'MACPET'))
class(MACPET_psfitData)
summary(MACPET_psfitData)
summary(MACPET_psfitData,threshold=1e-5)

#load Intra-chromosomal data: (class=PIntra)
load(system.file('extdata', 'MACPET_pintraData.rda', package = 'MACPET'))
class(MACPET_pintraData)
summary(MACPET_pintraData)
requireNamespace('ggplot2')
requireNamespace('reshape2')
summary(MACPET_pintraData,heatmap=TRUE)#sample data, not good heatmap plot.

#load Inter-chromosomal data: (class=PInter)
load(system.file('extdata', 'MACPET_pinterData.rda', package = 'MACPET'))
class(MACPET_pinterData)
summary(MACPET_pinterData)
requireNamespace('ggplot2')
requireNamespace('reshape2')
summary(MACPET_pinterData,heatmap=TRUE)#sample data, not good heatmap plot.

#load Interaction data: (class=GenomeMap)
load(system.file('extdata', 'MACPET_GenomeMapData.rda', package = 'MACPET'))
class(MACPET_GenomeMapData)
summary(MACPET_GenomeMapData)
}
\references{
Vardaxis I, Drabløs F, Rye M and Lindqvist BH (2018). \emph{MACPET: Model-based Analysis for ChIA-PET}.
To be published.
}
\seealso{
\code{\linkS4class{PSelf}},
\code{\linkS4class{PSFit}},
\code{\linkS4class{PInter}},\code{\linkS4class{PIntra}},
\code{\linkS4class{GenomeMap}}
}
\author{
Ioannis Vardaxis, \email{ioannis.vardaxis@ntnu.no}
}
