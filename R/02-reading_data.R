read_census <- function(file_path, save_path) {
  # Download the Spanish data
  ## data_link <- "ftp://www.ine.es/temas/censopv/cen11/Microdatos_personas_nacional.zip"
  ## download.file(data_link, destfile = "./data/raw_data.zip")
  ## unzip("./data/raw_data.zip", exdir = "./data/")

  message("The microdatos file is being read. This can take some time but",
          "this is only run if the preprocessed file is not saved. Once this",
          "is run once it will not run again.")
  
  censo <-
    censo2010(
      file_path
    )

  censo
}

read_codebook_labels <- function(file_path) {
  ## variables_link <- "ftp://www.ine.es/temas/censopv/cen11/Personas%20detallado_WEB.xls"
  ## download.file(variables_link, destfile = "./data/variable_labels.xls")
  variable_coding <-
    read_xls(
      file_path,
      col_names = FALSE,
      skip = 5
    )

  # Fix up variable names
  variable_coding <-
    set_names(variable_coding, paste0("X", 1:ncol(variable_coding)))

  variable_coding
}
