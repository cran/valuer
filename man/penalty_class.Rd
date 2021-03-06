% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parameters.R
\docType{class}
\name{penalty_class}
\alias{penalty_class}
\title{Surrender penalty class}
\format{\code{\link{R6Class}} object.}
\usage{
penalty_class
}
\value{
Object of \code{\link{R6Class}}
}
\description{
Class providing a surrender charge. It supports a constant surrender
charge (type 1) and two surrender charges decreasing with time,
(type 2 and type 3).
}
\section{Methods}{

\describe{
  \item{\code{new}}{Initialization methods with arguments:
  \describe{
   \item{\code{type}}{type of the surrender charge. It can be
   1 (constant) or 2 or 3 (decreasing with time).}
   \item{\code{const}}{positive integer between 0 and 1
   with the maximum surrender charge.}
   \item{\code{T}}{Positive integer with expiry of the VA product.}
  }
 }
  \item{\code{get}}{get the surrender penalty. Argument is \code{time}
  a scalar in [0, T].}
  \item{\code{set}}{set the maximum surrender penalty.}
  \item{\code{get_type}}{get the type of the surrender penalty}
}
}

\examples{
#Sets a constant penalty
penalty <- penalty_class$new(type = 1, const = 0.03)
penalty$get()
penalty$set(0.04)
penalty$get()
#Sets a time decreasing penalty of type 2
penalty <- penalty_class$new(type = 2, const = 0.08, T = 10)
penalty$get(time = 0)
penalty$get(time = 2)
penalty$set(0.05)
penalty$get(time = 0)
#Sets a time decreasing penalty of type 3
penalty <- penalty_class$new(type = 3, const = 0.08, T = 10)
penalty$get(time = 0)
penalty$get(time = 2)
penalty$set(0.05)
penalty$get(time = 0)
}
\keyword{datasets}
