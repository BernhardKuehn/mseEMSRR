# p4om.R - DESC
# mseEMSRR/data-raw/p4om.R

# Copyright European Union, 2018
# Author: Iago Mosqueira (EC JRC) <iago.mosqueira@ec.europa.eu>
#
# Distributed under the terms of the European Union Public Licence (EUPL) V.1.1.

library(mseEMSRR)

library(FLa4a)
library(FLBRP)

data(ple4)
data(ple4.index)

stk <- ple4
idx <- FLIndices(BTS=ple4.index)

# Variables

it <- 50 # iterations
iy <- 2017 # initial year of projection (also intermediate)
fy <- 2030 # final year
y0 <- range(stk)["minyear"] # initial data year
dy <- range(stk)["maxyear"] # final data year
ny <- fy - iy + 1 # number of years to project from initial year
nsqy <- 3 # number of years to compute status quo metrics
vy <- ac(iy:fy) # vector of years to be projected

# Operating model conditioning

# fit stock assessment model
mcsave <- 200
mcmc <- mcsave * it
fit <- sca(stk, idx, fit="MCMC",
  mcmc = SCAMCMC(mcmc = mcmc, mcsave = mcsave, mcprobe = 0.4))

# stk <- slim(stk + fit)
stk <- stk + fit

# Make SRRs

# average recruitment estimation sd
rv1 <- sqrt(mean(c(iterVars(log(rec(stk)))), na.rm=TRUE))

# average autocor lag1
ac1 <- mean(apply(window(rec(stk), end=2008)@.Data, 6, function(x)
  c(acf(c(x), plot=FALSE, lag.max=1)$acf[2])))

# BevHolt
library(FLSRTMB)

srbh <- as.FLSR(stk, model="bevholtSV")
res <- lapply(seq(it), function(x)
  srrTMB(iter(srbh, x), spr0=spr0y(iter(stk, x))))

model(srbh) <- bevholt()
params(srbh) <- do.call(cbind, lapply(res, params))

# Deviances
devbh <- ar1rlnorm(rho=ac1, years=dy:fy, iters=it, margSD=rv1*2)
residuals(srbh) <- devbh

# Refpts

brp <- brp(FLBRP(stk, srbh))

# Set up future assumptions
stk <- fwdWindow(stk, brp, end=fy)
idx[["BTS"]] <- window(idx[["BTS"]], end=fy)

# Fleet behaviour
fb <- mseCtrl(method=hyperstability.fb, args=list(beta=0.8))

# OM object
om <- FLom(stock=stk, sr=srbh, refpts=remap(refpts(brp)),
  projection=mseCtrl(method=fwd.om))

# OEM

set.seed(3621)

oem <- FLoem(method=sampling.oem,
  observations=list(stk=stock(om), idx=lapply(idx, propagate, it)),
  deviances=list(
    stk=FLQuants(catch.n=rlnorm(it, catch.n(stock(om)) %=% 0, 0.1)),
    idx=lapply(idx, function(x) rlnorm(it, index(x) %=% 0, 0.3))
  ))


sel.pattern(observations(oem)$idx[[1]]) <- window(catch.sel(stk), start=1996)

# SAVE

save(om, oem, file="../data/ple4om.rda", compress="xz")
