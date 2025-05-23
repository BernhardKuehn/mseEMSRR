% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/is.R
\name{tac.is}
\alias{tac.is}
\title{TAC implementation system module}
\usage{
tac.is(
  stk,
  ctrl,
  args,
  output = "catch",
  recyrs = -2,
  Fdevs = fbar(fut) \%=\% 1,
  dtaclow = NA,
  dtacupp = NA,
  fmin = 0,
  reuse = TRUE,
  initac = metrics(stk, output)[, ac(iy - 1)],
  tracking
)
}
\arguments{
\item{stk}{The perceived FLStock.}

\item{ctrl}{The fwdControl output by the \emph{hcr} step, target must be 'fbar'.}

\item{args}{The MSE run arguments.}

\item{recyrs}{Years to use for geometric mean recruitment if projection. Defaults to all years minus the last two.}

\item{Fdevs}{Deviances on the fbar input to incorporate error and bias when MP is run using the pseudo-estimators 'perfect.sa' or 'shortcut.sa'.}

\item{dtaclow}{Limit to decreases in output catch, as a proportional change (0.85 for 15\%). Applied only when metric > lim, as set by 'hcr' step.}

\item{dtacupp}{Limit to increases in output catch, as a proportional change (1.15 for 15\%). Applied only when metric > lim, as set by 'hcr' step.}

\item{fmin}{Minimum fbar to apply when catch change limits are use.}

\item{initac}{Initial catch from which to compute catch change limits. Defaults to previous observed catch.}

\item{tracking}{The tracking object.}
}
\description{
Performs a short term forecast (STF) for the target fishing mortality to
obtain the corresponding catch.
}
\details{
A \code{fwdControl} object obtained from the 'hcr' step is applied in the
management year (\code{ay + mlag}) or years (\verb{seq(ay + mlag, ay + mlag + freq}).
An assumption is made on the mortality in the assessment year (\code{ay}), which
becomes the intermediate year in this projection. By default this is set
to Fbar = Fsq, that is, the same fishing mortality estimated in the
last data year (\code{ay - data_lag}).

The projection applies a constant recruitment, equal to the geometric mean
over an specified number of years. By default all years minus the last two
are included in the calculation. An specific set of years can be employed,
by specifying a character vector of year names, or two values can be given
for the number of years to be inlcuded, counting from the last, and how many
years to exclude at the end. For example, \code{c(30, 2)} will use the last 30
years but excluding the last two, usually worst estimated.
}
\examples{
data(sol274)
# Setup control with tac.is
control <- mpCtrl(list(est=mseCtrl(method=perfect.sa),
  hcr=mseCtrl(method=hockeystick.hcr,
    args=list(lim=0, trigger=4.3e5, target=0.21)),
  isys=mseCtrl(method=tac.is, args=list(recyrs=-3, output='landings'))))
# Run MP until 2025
run <- mp(om, oem, ctrl=control, args=list(iy=2021, fy=2027))
# Plot run time series
plot(om, TAC.IS=run)
}
