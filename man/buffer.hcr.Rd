% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hcr.R
\name{buffer.hcr}
\alias{buffer.hcr}
\title{A buffered and non-linear hockeystick HCR}
\usage{
buffer.hcr(
  stk,
  ind,
  target,
  metric = "depletion",
  lim = 0.1,
  bufflow = 0.3,
  buffupp = 0.5,
  sloperatio = 0.2,
  initac = NULL,
  dupp = NULL,
  dlow = NULL,
  all = TRUE,
  ...,
  args,
  tracking
)
}
\arguments{
\item{lim}{Point at which the HCR response moves from linear to quadratic in terms of reducing HCR multiplier, numeric.}

\item{bufflow}{Lower point of "buffer zone" where HCR response is fixed at 1.}

\item{buffupp}{Upper point of "buffer zone" where HCR response is fixed at 1.}

\item{sloperatio}{fractional difference

so the response of the HCR in this case would be as follows:
if(muI > Ilim & muI <= buffl) HCRmult <- (0.5*(1+(muI-Ilim)/(buffl-Ilim)))
if(muI > buffl & muI < buffh) HCRmult <- 1
if(muI >= buffh) HCRmult <- 1+sloperatio\emph{gr}(muI-buffh)
if(muI <= Ilim) HCRmult <- (muI/Ilim)^2/2}
}
\description{
A Harvest Control Rule (HCR) that extends the traditional hockeystick shape
by allowing for increasing output when stock status rises above a buffer set
around the target.
}
\references{
Hillary, R. 2020. \emph{Management Strategy Evaluation of the Broadbill Swordfish ETBF harvest strategies}. Working document.
}
\author{
Original design by R. Hillary (CSIRO). Implemented by I. Mosqueira (WMR).
}
