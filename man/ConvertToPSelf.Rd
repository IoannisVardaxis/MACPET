% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ConvertToPSelf-methods.R
\docType{methods}
\name{ConvertToPSelf}
\alias{ConvertToPSelf}
\alias{ConvertToPSelf.default}
\alias{ConvertToPSelf.GInteractions}
\alias{ConvertToPSelf,GInteractions-method}
\alias{ConvertToPSelf,GInteractions,ConvertToPSelf-method}
\title{Convert GInteraction object to PSelf object}
\usage{
ConvertToPSelf(object, ...)

\method{ConvertToPSelf}{default}(object, ...)

\method{ConvertToPSelf}{GInteractions}(object, S2_BlackList, SA_prefix,
  S2_AnalysisDir, ...)

\S4method{ConvertToPSelf}{GInteractions}(object, S2_BlackList, SA_prefix,
  S2_AnalysisDir, ...)
}
\arguments{
\item{object}{An object of \code{\link[InteractionSet:GInteractions-class]{GInteractions}} class.}

\item{...}{not used.}

\item{S2_BlackList}{See  \code{\link{MACPETUlt}}.}

\item{SA_prefix}{See  \code{\link{MACPETUlt}}.}

\item{S2_AnalysisDir}{The directory in which the object will be saved.}
}
\value{
An object of class \code{\linkS4class{PSelf}}.
}
\description{
\code{ConvertToPSelf} converts a \code{\link[InteractionSet:GInteractions-class]{GInteractions}} object to
class to \code{\linkS4class{PSelf}} object.
}
\details{
\code{\link{MACPETUlt}} at State 2 separates the Inter-chromosomal,
 Intra-chromosomal and Self-ligated PETs by taking
the paired-end BAM/SAM file as input. However the user might only have
Self-ligated data available and already separated from the Inter/Intra-chromosomal
PETs. \code{ConvertToPSelf} can then be used in the Self-ligated data to convert
a \code{\link[InteractionSet:GInteractions-class]{GInteractions}} object containing only the Self-ligated
PETs to a \code{\linkS4class{PSelf}} class for further analysis in Stage 3.
The object will be saved in the \code{S2_AnalysisDir} directory with the
 name \code{SA_prefix_pselfData}.
Note that if \code{S2_BlackList==TRUE} then the \code{\link[InteractionSet:GInteractions-class]{GInteractions}}
object given as input has to include the genome name in the \code{seqinfo} slot.
Also, the sequences lengths are mandatory in the \code{seqinfo} slot since they
are used in stage 3 of the analysis.
}
\examples{
#load Self-ligated data: (class=PSelf)
load(system.file('extdata', 'MACPET_pselfData.rda', package = 'MACPET'))
class(MACPET_pselfData)

object=MACPET_pselfData
#--remove information and convert to GInteractions:
S4Vectors::metadata(object)=list(NULL)
class(object)='GInteractions'
#----input parameters
S2_BlackList=TRUE
SA_prefix='MACPET'
S2_AnalysisDir=file.path(tempdir(),'MACPETtest')
if(!dir.exists(S2_AnalysisDir)) dir.create(S2_AnalysisDir)

ConvertToPSelf(object=object,
                      S2_BlackList=S2_BlackList,
                      SA_prefix=SA_prefix,
                      S2_AnalysisDir=S2_AnalysisDir)
#load object:
rm(MACPET_pselfData)#old object
load(file.path(S2_AnalysisDir,'MACPET_pselfData'))
class(MACPET_pselfData)
#-----delete test directory:
unlink(S2_AnalysisDir,recursive=TRUE)

}
\references{
Vardaxis I, Drabløs F, Rye M and Lindqvist BH (2018). \emph{MACPET: Model-based Analysis for ChIA-PET}.
To be published.
}
\seealso{
\code{\linkS4class{PSelf}}
}
\author{
Ioannis Vardaxis, \email{ioannis.vardaxis@ntnu.no}
}
