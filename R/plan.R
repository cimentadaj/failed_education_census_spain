####################### Read Census 1991 data #################################
###############################################################################

# This is the preprocessed data
processed_path_1991 <- here("data", "1991_census.fst")
# If the preprocessed data does not exist, read the raw
# data and resave the file. The preprocessed data is just
# the raw data saved in another format which is much faster
# to deal with in R (because the census is too big).
if (!file.exists(processed_path_1991)) {
  data_path <- here("raw_data", "censo_1991", "provincias")
  data_paths <- list.files(data_path,
                           pattern = "zip$",
                           full.names = TRUE)

  message("The census 1991 microdatos file is being read. This can take some time but ",
          "this is only run if the preprocessed file is not saved. Once this",
          "is run once it will not run again.")

  # Read the censo
  censo <-
    censo1991_provincias(
      data_paths
    )
  
  # Save it in a new (faster) format in the processed_path
  write_fst(censo, processed_path_1991)
}


####################### Read Census 2001 data #################################
###############################################################################

# This is the preprocessed data
processed_path_2001 <- here("data", "2001_census.fst")

# If the preprocessed data does not exist, read the raw
# data and resave the file. The preprocessed data is just
# the raw data saved in another format which is much faster
# to deal with in R (because the census is too big).
if (!file.exists(processed_path_2001)) {
  data_path <- here("raw_data", "censo_2001", "provincias")
  data_paths <- list.files(data_path,
                           pattern = "zip$",
                           full.names = TRUE)

  message("The census 2001 microdatos file is being read. This can take some time but ",
          "this is only run if the preprocessed file is not saved. Once this",
          "is run once it will not run again.")
  
  # Read the censo
  censo <-
    censo2001_provincias(
      data_paths
    )

  # Save it in a new (faster) format in the processed_path
  write_fst(censo, processed_path_2001)
}

############################# Read Census 2011 data ###########################
###############################################################################

# This is the preprocessed data
processed_path_2011 <- here("data", "2011_census.fst")

# If the preprocessed data does not exist, read the raw
# data and resave the file. The preprocessed data is just
# the raw data saved in another format which is much faster
# to deal with in R (because the census is too big).
if (!file.exists(processed_path_2011)) {
  data_path <- here("raw_data", "censo_2011")
  data_paths <- list.files(data_path,
                           pattern = "zip$",
                           full.names = TRUE)

  message("The census 2011 microdatos file is being read. This can take some time but ",
          "this is only run if the preprocessed file is not saved. Once this",
          "is run once it will not run again.")

  # Read the censo
  censo <-
    censo2010(
      data_paths
    )

  # Save it in a new (faster) format in the processed_path
  write_fst(censo, processed_path_2011)

}

###################### Read the 2011 census codebook #########################
###############################################################################

## variables_link <- "ftp://www.ine.es/temas/censopv/cen11/Personas%20detallado_WEB.xls"
## download.file(variables_link, destfile = "./data/variable_labels.xls")

labels_path <- here("raw_data", "censo_2011", "variable_labels.xls")

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

# Column FACTOR is not available in 2001 but only in 2011
# FACTOR is the weight column. Maybe we have to use weights in
# 2011 but not in 2001. Anyaywas, exlcuding for now.
# In the 1991 census, the weight column is
codebook <- list()

codebook$variable_descr <-
  c("Code of province currently living",
    "Code of municipality currently living",
    "Family unique ID",
    "Respondet unique ID (within family)",
    "Month of birth",
    "Year of birth",
    "Age",
    "Gender",
    "Country of birth (for 1991 it's nationality)")

# CPRO, CMUN, IDHUECO, NORDEN uniquely identify
codebook$census_2011 <- c("CPRO", # Code province
                          "CMUN", # Code municipality
                          "IDHUECO", # Family code
                          "NORDEN",# Respondent code inside family
                          ## "FACTOR",
                          "MNAC", # Month of birth
                          "ANAC", # Year of birth
                          "EDAD", # Age
                          "SEXO", # Gender
                          "NACI")

# CPRO, CMUN, NSS, HUECO, NORDF uniquely identify
codebook$census_2001 <- c("CPRO", # Code province
                          "CMUN", # Code municipality,
                          "NSS" # Número Secuencial de Sección
                          "HUECO", # Family code
                          "NORDF",# Respondent code inside family
                          ## "FACTOR",
                          "MNAC", # Month of birth
                          "ANAC", # Year of birth
                          "EDAD", # Age
                          "SEXO", # Gender
                          "NACI")

codebook$census_1991 <- c("PRO", # Code province
                          "MUN(1)", # Code municipality
                          ## "HUECO", # Family code
                          ## "NORDF",# Respondent code inside family
                          ## "FACTOR",
                          "MES", # Month of birth
                          "FECHA", # Year of birth
                          "EDAD", # Age
                          "SEXO", # Gender
                          # NACINB is the nationality rather than the place
                          # where one was born
                          "NACINB")

class(codebook$census_2011) <- c("census_2011", class(codebook$census_2011))
class(codebook$census_2001) <- c("census_2001", class(codebook$census_2001))
class(codebook$census_1991) <- c("census_1991", class(codebook$census_1991))

codebook <- as_tibble(codebook)

plan <-
  drake_plan(
    
    ############################# Read the data 2001 ###########################
    ############################################################################
    
    census_2001 =
      target(
        read_census(file_in(processed_path_2001),
                    shp_file,
                    codebook$census_2001),
        format = "fst"
      ),

    ############################# Read the data 2011 ###########################
    ############################################################################

    census_2011 =
      target(
        read_census(file_in(processed_path_2011),
                    shp_file,
                    codebook$census_2011),
        format = "fst"
      )
  )
