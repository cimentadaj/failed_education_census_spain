source("./R/01-packages.R")  # Load your packages, e.g. library(drake).
source("./R/02-analysis.R")  # Create your analysis through functions here
source("./R/plan.R")      # Create your drake plan.

# _drake.R must end with a call to drake_config().
# The arguments to drake_config() are basically the same as those to make().
# options(clustermq.scheduler = "multicore") # For parallel computing.

drake_config(
  plan
)
