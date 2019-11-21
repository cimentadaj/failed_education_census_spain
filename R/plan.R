############################# Read Census 2011 data ###########################
###############################################################################

# This is the preprocessed data
processed_path <- here("data", "2011_census.fst")

# If the preprocessed data does not exist, read the raw
# data and resave the file. The preprocessed data is just
# the raw data saved in another format which is much faster
# to deal with in R (because the census is too big).
if (!file.exists(processed_path)) {
  data_path <- here("raw_data", "MicrodatosCP_NV_per_nacional_3VAR.txt")

  message("The microdatos file is being read. This can take some time but",
          "this is only run if the preprocessed file is not saved. Once this",
          "is run once it will not run again.")

  # Read the censo
  censo <-
    censo2010(
      data_path
    )

  # Save it in a new (faster) format in the processed_path
  write_fst(censo, processed_path)

}

############################# Read the codebook ###############################
###############################################################################

## variables_link <- "ftp://www.ine.es/temas/censopv/cen11/Personas%20detallado_WEB.xls"
## download.file(variables_link, destfile = "./data/variable_labels.xls")

labels_path <- here("raw_data", "variable_labels.xls")

variable_coding <-
  read_xls(
    labels_path,
    col_names = FALSE,
    skip = 5
  )

# Fix up variable names
variable_coding <-
  set_names(variable_coding, paste0("X", 1:ncol(variable_coding)))

############################# Drake plan of analysis ##########################
###############################################################################

shp_file <-
  here("raw_data/shape_files_censustract/SECC_CPV_E_20111101_01_R_INE.shp")

columns_to_read <- c("CPRO",
                     "CMUN",
                     "IDHUECO",
                     "NORDEN",
                     "FACTOR",
                     "MNAC",
                     "ANAC",
                     "EDAD",
                     "SEXO",
                     "NACI")

plan <-
  drake_plan(
    ############################# Read the data ################################
    ############################################################################

    census_2011 =
      target(
        read_census(file_in(processed_path),
                    shp_file,
                    columns = columns_to_read),

        format = "fst"
      )

  )
