% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/FLiem-class.R
\docType{class}
\name{FLiem-class}
\alias{FLiem-class}
\alias{FLiem}
\alias{initialize,FLiem-method}
\alias{FLiem-methods}
\alias{iter,FLiem-method}
\title{S4 class \code{FLiem}}
\usage{
\S4method{initialize}{FLiem}(.Object, ...)

\S4method{iter}{FLiem}(obj, iter)
}
\arguments{
\item{...}{additional argument list that might never be used}

\item{object}{object of relevant class (see signature of method)}
}
\description{
The \code{FLiem} class stores the information relative to the implementation error model of the MSE.
}
\section{Slots}{

\describe{
\item{method}{\code{character} with the name of the method to be run. Note a function of method must exist in the environment with the same name.}
\item{args}{\code{list} with arguments to be passed to the function defined in \code{method}}
}

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

