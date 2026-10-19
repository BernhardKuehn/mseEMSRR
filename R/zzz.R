.onLoad <- function(libname, pkgname) {
  conflicts <- switch(
    pkgname,
    mseEMSRR = c("mse"),
    FLasherEMSRR = c("FLasher"),
    character()
  )
  
  loaded_conflicts <- intersect(conflicts, loadedNamespaces())
  
  if (length(loaded_conflicts) > 0L) {
    warning(
      sprintf(
        "%s cannot be loaded while %s is loaded. ",
        pkgname,
        paste(loaded_conflicts, collapse = ", ")
      ),
      "These packages define incompatible S4 classes with the same names. ",
      "Restart R and load only the EMSRR forks."
    )
  }
}