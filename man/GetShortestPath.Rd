% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/GetShortestPath-methods.R
\docType{methods}
\name{GetShortestPath}
\alias{GetShortestPath}
\alias{GetShortestPath.default}
\alias{GetShortestPath.GenomeMap}
\alias{GetShortestPath,GenomeMap-method}
\alias{GetShortestPath,GenomeMap,GetShortestPath-method}
\title{Find shortest path between pairs of peaks given a set of significant interactions.}
\usage{
GetShortestPath(object, ...)

\method{GetShortestPath}{default}(object, ...)

\method{GetShortestPath}{GenomeMap}(object, threshold = NULL, ChrFrom,
  ChrTo, SummitFrom, SummitTo, ...)

\S4method{GetShortestPath}{GenomeMap}(object, threshold = NULL, ChrFrom,
  ChrTo, SummitFrom, SummitTo, ...)
}
\arguments{
\item{object}{An object of class \code{\linkS4class{GenomeMap}}.}

\item{...}{Further arguments to be passed to \code{GetShortestPath} (not used).}

\item{threshold}{A numeric with the FDR cut-off threshold used to take a
subset of significant interactions If \code{threshold=NULL}
then  all the interactions will be used}

\item{ChrFrom}{Character specifying the chromosome of the 'From' peak, for example 'chr1'.}

\item{ChrTo}{Character specifying the chromosome of the 'To' peak.}

\item{SummitFrom}{Numeric specifying the peak summit of the 'From' peak.}

\item{SummitTo}{Numeric specifying the peak summit of the 'To' peak.}
}
\value{
A two-element list with the first element named \code{LinearPathLength}
for the linear length of the path between \code{SummitFrom} and \code{SummitTo},
and the second element named \code{ThreeDPathLength} for the 3D length of the shortest path
between \code{SummitFrom} and \code{SummitTo}.
}
\description{
\code{GetShortestPath} function subsets the significant interactions of a \code{\linkS4class{GenomeMap}} object
given a user specified FDR cut-off. Based on the leftover interactions, it creates a network and finds the length of the
shortest path between two user-specified peaks. Currently it only finds the shortest paths between intra-chromosomal peaks.
Therefore, the peaks have to be on the same chromosome.
}
\examples{

#load Interaction data: (class=GenomeMap)
load(system.file('extdata', 'MACPET_GenomeMapData.rda', package = 'MACPET'))
class(MACPET_GenomeMapData)
GetShortestPath(object=MACPET_GenomeMapData,
                    threshold = NULL,
                    ChrFrom='chr1',
                    ChrTo='chr1',
                    SummitFrom=10000,
                    SummitTo=1000000)

}
\references{
Vardaxis I, Drabløs F, Rye M and Lindqvist BH (2018). \emph{MACPET: Complete pipeline for ChIA-PET}.
To be published.
}
\seealso{
\code{\linkS4class{GenomeMap}}
}
\author{
Ioannis Vardaxis, \email{ioannis.vardaxis@ntnu.no}
}
