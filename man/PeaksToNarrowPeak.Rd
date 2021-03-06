% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/PeaksToNarrowPeak-methods.R
\docType{methods}
\name{PeaksToNarrowPeak}
\alias{PeaksToNarrowPeak}
\alias{PeaksToNarrowPeak.default}
\alias{PeaksToNarrowPeak.PSFit}
\alias{PeaksToNarrowPeak,PSFit-method}
\alias{PeaksToNarrowPeak,PSFit,PeaksToNarrowPeak-method}
\title{Convert Peaks to narrowPeak (BED) object.}
\usage{
PeaksToNarrowPeak(object, ...)

\method{PeaksToNarrowPeak}{default}(object, ...)

\method{PeaksToNarrowPeak}{PSFit}(object, threshold = NULL, savedir,
  file.out, ...)

\S4method{PeaksToNarrowPeak}{PSFit}(object, threshold = NULL, savedir,
  file.out, ...)
}
\arguments{
\item{object}{An object of class \code{\linkS4class{PSFit}}.}

\item{...}{Further arguments to be passed to \code{PeaksToNarrowPeak} (not used).}

\item{threshold}{A numeric with the FDR cut-off threshold used to take a
subset of significant peaks. If \code{threshold=NULL}
then  all the peaks are returned.}

\item{savedir}{A string with the directory to save the ouput file.}

\item{file.out}{A string with the name of the output to be saved to
\code{savedir}.}
}
\value{
A \code{narrowPeak} object named after the value of \code{file.out} and saved in the \code{savedir.}
}
\description{
\code{PeaksToNarrowPeak} converts peaks of an object of \code{\linkS4class{PSFit}}
class to \code{narrowPeak} object. The object is saved in a user specified directory and can be used in the
MANGO or MICC algorithms for interaction analysis. Alternatively, the user can run stage 4 at \code{\link{MACPETUlt}}.
}
\details{
Each Peak in the narrowPeak object is represented by an interval starting from the 'CIQ.Up.start'
estimated variable to its 'CIQ.Down.end' (see \code{\linkS4class{PSFit}}). Close Peaks in genomic distance are NOT
merged by the \code{PeaksToNarrowPeak} function. However the user can specify a distance window for merging in the
MANGO or MICC algorithms. Note also that MANGO and MICC find a self-ligated cut-off by itself which is usually very different than
that found by MACPET. We suggest that the user overwrites MANGOS's or MICC's cut-off with that of MACPET.
}
\examples{
#Create a temporary forder, or anywhere you want:
savedir=file.path(tempdir(),'MACPETtest')
dir.create(savedir)#where you will save the results
file.out='MACPET_peaks.narrowPeak'

#load Self-ligated data: (class=PSFit)
load(system.file('extdata', 'MACPET_psfitData.rda', package = 'MACPET'))
class(MACPET_psfitData)
PeaksToNarrowPeak(object=MACPET_psfitData,threshold=1e-5,file.out=file.out,savedir=savedir)

#-----delete test directory:
unlink(savedir,recursive=TRUE)
}
\references{
Vardaxis I, Drabløs F, Rye M and Lindqvist BH (2018). \emph{MACPET: Model-based Analysis for ChIA-PET}.
To be published.
}
\seealso{
\code{\linkS4class{PSFit}}
}
\author{
Ioannis Vardaxis, \email{ioannis.vardaxis@ntnu.no}
}
