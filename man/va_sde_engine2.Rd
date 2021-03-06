% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/va_pricing_engine4.R
\docType{class}
\name{va_sde_engine2}
\alias{va_sde_engine2}
\title{Variable Annuity pricing engine with general financial processes and
Weibull mortality}
\format{\code{\link{R6Class}} object.}
\usage{
va_sde_engine2
}
\value{
Object of \code{\link{R6Class}}
}
\description{
Class providing a variable annuity pricing engine where the underlying
reference fund and interest rates are specified by an arbitrary
system of stochastic differential equations. In contrast the intensity
of mortality is deterministic and given by the Weibull function.
The financial paths are simulated by means of the
\href{https://CRAN.R-project.org/package=yuima}{yuima} package. \cr
The value of the VA contract is estimated by means of the Monte Carlo
method if the policyholder cannot surrender (the so called "static"
approach), and by means of Least Squares Monte Carlo in case the
policyholder can surrender the contract (the "mixed" approach).\cr
See \bold{References} -\code{[BMOP2011]} for a description of the mixed
and static approaches and the algorithm implemented by this class,
\code{[LS2001]} for Least Squares Monte Carlo and \code{[YUIMA2014]}
for \code{yuima}.
}
\section{Methods}{

\describe{
 \item{\code{new}}{Constructor method with arguments:
  \describe{
   \item{\code{product}}{A \code{\link{va_product}}
   object with the VA product.}
   \item{\code{financial_parms}}{A list of parameters
   specifying the financial processes.
   See \code{\link{financials_BZ2016}} for an example.}
   \item{\code{c1}}{\code{numeric} scalar argument of the intensity
   of mortality function \code{\link{mu}}}
   \item{\code{c2}}{\code{numeric} scalar argument of the intensity
   of mortality function \code{\link{mu}}}
  }
 }
 \item{\code{death_time}}{Returns the time of death index. If the
 death doesn't occur during the product time-line it returns the
 last index of the product time-line plus one.}
 \item{\code{simulate_financial_paths}}{Simulates \code{npaths} paths
 of the underlying fund of the VA contract and the discount factors
 (interest rate) and saves them into private fields for later use.}
 \item{\code{simulate_mortality_paths}}{Simulates \code{npaths} paths
 of the intensity of mortality and saves them into private fields
 for later use.}
 \item{\code{get_fund}}{Gets the \code{i}-th path of the underlying fund
 where \code{i} goes from 1 to \code{npaths}.}
 \item{\code{do_static}}{Estimates the VA contract value by means of
 the static approach (Monte Carlo), see \bold{References}. It takes as
 arguments:
  \describe{
    \item{\code{the_gatherer}}{\code{gatherer} object to hold
    the point estimates}
    \item{\code{npaths}}{positive integer with the number of paths to
    simulate}
    \item{\code{simulate}}{boolean to specify if the paths should be
    simulated from scratch, default is TRUE.}
  }
 }
 \item{\code{do_mixed}}{Estimates the VA contract by means of
 the mixed approach (Least Squares Monte Carlo), see \bold{References}.
 It takes as arguments:
  \describe{
   \item{\code{the_gatherer}}{\code{gatherer} object to hold
    the point estimates}
    \item{\code{npaths}}{positive integer with the number of paths to
    simulate}
    \item{\code{degree}}{positive integer with the maximum degree of
    the weighted Laguerre polynomials used in the least squares by LSMC}
    \item{\code{freq}}{string which contains the frequency of the surrender
    decision. The default is \code{"3m"} which corresponds to deciding every
    three months if surrendering the contract or not.}
    \item{\code{simulate}}{boolean to specify if the paths should be
    simulated from scratch, default is TRUE.}
  }
 }
 \item{\code{get_discount}}{Arguments are \code{i,j}.
 Gets the \code{j}-th discount factor corresponding to the \code{i}-th
 simulated path of the discount factors.}
 \item{\code{fair_fee}}{Calculates the fair fee for a contract using the
 bisection method. Arguments are:
  \describe{
   \item{\code{fee_gatherer}}{\code{\link{data_gatherer}} object to hold
   the point estimates}
   \item{\code{npaths}}{\code{numeric} scalar with the number of MC
   simulations to run}
   \item{\code{lower}}{\code{numeric} scalar with the lower fee corresponding
   to positive end of the bisection interval}
   \item{\code{upper}}{\code{numeric} scalar with the upper fee corresponding
   to the negative end of the bisection interval}
   \item{\code{mixed}}{\code{boolean} specifying if the mixed method has
   to be used. The default is \code{FALSE}}
   \item{\code{tol}}{\code{numeric} scalar with the tolerance of the
   bisection algorithm. Default is \code{1e-4}}
   \item{\code{nmax}}{positive \code{integer} with the maximum number of
   iterations of the bisection algorithm}
   \item{\code{simulate}}{boolean specifying if financial and mortality
   paths should be simulated.}
  }
 }
}
}

\examples{
#Sets up the payoff as a roll-up of premiums with roll-up rate 2\%

rate <- constant_parameters$new(0.02)

premium <- 100
rollup <- payoff_rollup$new(premium, rate)

#Five years time-line
begin <- timeDate::timeDate("2016-01-01")
end <- timeDate::timeDate("2020-12-31")

#Age of the policyholder.
age <- 50
# A constant fee of 2\% per year (365 days)
fee <- constant_parameters$new(0.02)

#Barrier for a state-dependent fee. The fee will be applied only if
#the value of the account is below the barrier
barrier <- 200
#Withdrawal penalty applied in case the insured surrenders the contract
#It is a constant penalty in this case
penalty <- penalty_class$new(type = 1, 0.02)
#Sets up the contract with GMAB guarantee
contract <- GMAB$new(rollup, t0 = begin, t = end, age = age, fee = fee,
barrier = barrier, penalty = penalty)

#Sets up a gatherer of the MC point estimates
the_gatherer  <- mc_gatherer$new()
no_of_paths <- 10

#Sets up the pricing engine
engine <- va_sde_engine2$new(contract, financials_BMOP2011)

#Estimates the contract value by means of the static approach

engine$do_static(the_gatherer, no_of_paths)
the_gatherer$get_results()


#Estimates the contract value by means of the mixed approach
#To compare with the static approach we don't simulate the underlying
#fund paths again.

the_gatherer_2 <- mc_gatherer$new()

engine$do_mixed(the_gatherer_2, no_of_paths, degree = 3, freq = "3m",
simulate = FALSE)
the_gatherer_2$get_results()
}
\references{
\enumerate{
 \item{[BMOP2011]}{ \cite{Bacinello A.R., Millossovich P., Olivieri A.
 ,Pitacco  E., "Variable annuities: a unifying valuation approach."
 In: Insurance: Mathematics and Economics 49 (2011), pp. 285-297.}}
 \item{[LS2001]}{ \cite{Longstaff F.A. e Schwartz E.S. Valuing
 american options by simulation: a simple least-squares approach.
 In: Review of Financial studies 14 (2001), pp. 113-147}}
 \item{[YUIMA2014]}{ \cite{Alexandre Brouste, Masaaki Fukasawa, Hideitsu
  Hino, Stefano M. Iacus, Kengo Kamatani, Yuta Koike, Hiroki Masuda,
  Ryosuke Nomura, Teppei Ogihara, Yasutaka Shimuzu, Masayuki Uchida,
  Nakahiro Yoshida (2014). The YUIMA Project: A Computational
  Framework for Simulation and Inference of Stochastic Differential
  Equations. Journal of Statistical Software, 57(4), 1-51.
  URL http://www.jstatsoft.org/v57/i04/.}}
 }
}
\keyword{datasets}
