if ("mse" %in% loadedNamespaces()) {
  stop(
    "Upstream package 'mse' is loaded. ",
    "Restart R and run the mseEMSRR tests without loading 'mse' or 'msemodules'."
  )
}

if ("FLasher" %in% loadedNamespaces()) {
  stop(
    "Upstream package 'FLasher' is loaded. ",
    "Restart R and run the mseEMSRR tests with FLasherEMSRR only."
  )
}

library(testthat)
library(mseEMSRR)

# Set default to short tests for R CMD check
if (Sys.getenv("MSE_TEST_SUITE") == "") {
  Sys.setenv(MSE_TEST_SUITE = "short")
}

test_check("mseEMSRR")
