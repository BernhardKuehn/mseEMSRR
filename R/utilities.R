# utilities.R - DESC
# mseEMSRR/R/utilities.R

# Copyright Iago MOSQUEIRA (WMR), 2021
# Author: Iago MOSQUEIRA (WMR) <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2

options(future.globals.maxSize=995*1024^2)

# merge (FLQuant, data.table) {{{

setMethod("merge", signature(x="FLQuant", y="data.table"),
  function(x, y, by="iter", ...) {

  # CONVERT FLQ to df, all options
  xd <- as.data.frame(x, cohort=TRUE, date=TRUE)

  # MERGE by
  return(merge(xd, y, by=by))
})

# }}}

# .combinegoFish {{{
.combinegoFish <- function(...) {
 
  res <- list(...)

  return(
  list(
    om = Reduce("combine", lapply(res, '[[', "om")),
    tracking = Reduce("combine", lapply(res, '[[', "tracking")),
    oem = Reduce("combine", lapply(res, '[[', "oem"))
		)
  )
}
# }}}

# find.original.name {{{

find.original.name <- function(fun) {

  # 'NULL' function
  if(is.null(formals(fun)))
     if(is.null(do.call(fun, args=list())))
       return("NULL")
  
  ns <- environment(fun)
  objects <- ls(envir = ns)
  
  if(isNamespace(ns))
    name <- getNamespaceName(ns)
  else
    name <- environmentName(ns)

  for (i in objects) {
    if (identical(fun, get(i, envir = environment(fun)))) {
        return(paste(name, i, sep="::"))                   
    }
  }
  return("NULL")
}
# }}}

# onAttach {{{
.onAttach <- function(lib,pkg) {
  registerDoSEQ()
}
# }}}

# combinations {{{

combinations <- function(...) {

  # GET all inputs
  args <- list(...)
  
  # GENERATE all combinations
  combs <- as.list(do.call(expand.grid, args))

  # DELETE attributes and RENAME
  attributes(combs) <- NULL
  names(combs) <- names(args)

  return(combs)
}
# }}}

# decisions {{{

#' @examples
#' data(sol274)
#' 

decisions <- function(x, years=dimnames(tracking(x))$year, iter=NULL) {

  # EXTRACT tracking and args
  trac <- tracking(x)
  args <- args(x)

  # USE year as numeric
  years <- as.numeric(years)

  # SET iters if not given
  if(is.null(iter))
    iter <- seq(dims(x)$iter)

  # FUNCTION to compute table along years
  .table <- function(d) {

    its <- dims(d)$iter
    dmns <- dimnames(d)

    if(its == 1) {
      data.frame(metric=dmns$metric, year=dmns$year, value=prettyNum(d))
    } else {
      data.frame(metric=dmns$metric, year=dmns$year,
        value=sprintf("%s (%s)", 
          prettyNum(apply(d, 1:5, median, na.rm=TRUE)),
          prettyNum(apply(d, 1:5, mad, na.rm=TRUE))))
    }
  }

  # COMPUTE tables
  res <- lapply(years, function(y) {

    # GET advice, data and management years
    ay  <-  y
    dy <- ay - args$data_lag
    my  <- ay + args$management_lag

    # SET metrics to extract

    # data
    dmet <- c("SB.om", "SB.obs", "SB.est", "met.hcr")
    dmet <- dmet[dmet %in% dimnames(trac)$metric]

    # advice
    amet <- c("decision.hcr", "fbar.hcr", "hcr", "fbar.isys", "isys",
      "fwd", "C.om")

    amet <- amet[amet %in% dimnames(trac)$metric]

    # SUBSET metrics from tracking
    dout <- trac[dmet, ac(dy),,,, iter]
    aout <- trac[amet, ac(ay),,,, iter]

    # COMPUTE diff metrics
    mout <- trac["SB.om", ac(my),,,,iter] / trac["SB.om", ac(ay),,,,iter]
    dimnames(mout)$metric <- "diff(SB.om)"

    # BIND into single table
    rbind(.table(dout), .table(aout), .table(mout))      
  })

  do.call(cbind, res)
}
# }}}

# loadlist {{{
loadlist <- function(file) {
  mget(load(file, verbose=FALSE, envir=(.NE <- new.env())), envir=.NE)
}
# }}}
