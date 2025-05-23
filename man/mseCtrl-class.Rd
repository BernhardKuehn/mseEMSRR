% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mseCtrl-class.R, R/mpCtrl-class.R
\docType{class}
\name{mseCtrl-class}
\alias{mseCtrl-class}
\alias{mseCtrl}
\alias{initialize,mseCtrl-method}
\alias{mseCtrl-methods}
\alias{method}
\alias{method-methods}
\alias{method,mseCtrl-method}
\alias{method<-}
\alias{method<--methods}
\alias{method<-,mseCtrl,function-method}
\alias{args}
\alias{args-methods}
\alias{args,mseCtrl-method}
\alias{args<-}
\alias{args<--methods}
\alias{args<-,mseCtrl,list-method}
\alias{show,mseCtrl-method}
\alias{exists}
\alias{exists,mseCtrl-method}
\title{S4 class \code{mseCtrl}}
\usage{
\S4method{initialize}{mseCtrl}(.Object, ..., method, args)

method(object, ...)

\S4method{method}{mseCtrl}(object)

method(object, ...) <- value

\S4method{method}{mseCtrl,function}(object) <- value

args(name)

\S4method{args}{mseCtrl}(name)

args(object, ...) <- value

\S4method{args}{mseCtrl,list}(object) <- value

\S4method{show}{mseCtrl}(object)

exists(
  x,
  where = -1,
  envir = if (missing(frame)) as.environment(where) else sys.frame(frame),
  frame,
  mode = "any",
  inherits = TRUE
)

\S4method{exists}{mseCtrl}(x)

exists(
  x,
  where = -1,
  envir = if (missing(frame)) as.environment(where) else sys.frame(frame),
  frame,
  mode = "any",
  inherits = TRUE
)
}
\arguments{
\item{...}{additional argument list that might never be used}

\item{object}{object of relevant class (see signature of method)}
}
\description{
The \code{mseCtrl} class stores information about how a specific
module will be run. The function contained in the \emph{method} slot will be
called with three sets of argument: those contained in the \emph{args} slot, the
\emph{args} argument to the call to the \emph{mp} function, and the inputs defined by
type of module being defined by a particular object. Please see the "Module
dispatch" section in the \emph{mse} Technical Manual.
}
\section{Slots}{

\describe{
\item{\code{method}}{The function to be run in the module call, class \emph{function}.}

\item{\code{args}}{Arguments to be passed to the method, of class \emph{list}.}
}}

\section{Accessors}{

All slots in the class have accessor and replacement methods defined that
allow retrieving and substituting individual slots.

The values passed for replacement need to be of the class of that slot.
A numeric vector can also be used when replacing FLQuant slots, and the
vector will be used to substitute the values in the slot, but not its other
attributes.
}

\section{Constructor}{

A construction method exists for this class that can take named arguments for
any of its slots. All slots are then created to match the requirements of the
class validity. If an unnamed \code{FLQuant} object is provided, this is used
for sizing, but not for populating any slot.
}

\examples{
ctl <- mseCtrl(method=function(stk, args, alpha) ssb(stk) * alpha,
  args=list(alpha=0.5))
ctl
method(ctl)
method(ctl) <- function(stk, args, beta) ssb(stk) * beta
args(ctl)
args(ctl) <- list(beta=0.9)
exists(ctl)
}
