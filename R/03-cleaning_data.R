select_few <- function(read_data) {
  variables <-
    c("CPRO", "CMUN", "IDHUECO", "NORDEN", "FACTOR", "MNAC", "ANAC", 
      "EDAD", "SEXO", "NACI")

  select(read_data, variables)
}
