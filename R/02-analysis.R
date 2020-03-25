read_census <- function(processed_path, shp_file, columns_to_read) {
  # Columns to read has the census specific class for dispatch
  UseMethod("read_census", object = columns_to_read)
}

read_census.census_2001 <- function(processed_path, shp_file, columns_to_read) {
  recode_prov <- c(
    "Araba/Álava" = "01",
    "Albacete" = "02",
    "Alicante/Alacant" = "03",
    "Almería" = "04",
    "Ávila" = "05",
    "Badajoz" = "06",
    "Balears, Illes" = "07",
    "Barcelona" = "08",
    "Burgos" = "09",
    "Cáceres" = "10",
    "Cádiz" = "11",
    "Castellón/Castelló" = "12",
    "Ciudad Real" = "13",
    "Córdoba" = "14",
    "Coruña, A" = "15",
    "Cuenca" = "16",
    "Girona" = "17",
    "Granada" = "18",
    "Guadalajara" = "19",
    "Gipuzkoa" = "20",
    "Huelva" = "21",
    "Huesca" = "22",
    "Jaén" = "23",
    "León" = "24",
    "Lleida" = "25",
    "Rioja, La" = "26",
    "Lugo" = "27",
    "Madrid" = "28",
    "Málaga" = "29",
    "Murcia" = "30",
    "Navarra" = "31",
    "Ourense" = "32",
    "Asturias" = "33",
    "Palencia" = "34",
    "Palmas, Las" = "35",
    "Pontevedra" = "36",
    "Salamanca" = "37",
    "Santa Cruz de Tenerife" = "38",
    "Cantabria" = "39",
    "Segovia" = "40",
    "Sevilla" = "41",
    "Soria" = "42",
    "Tarragona" = "43",
    "Teruel" = "44",
    "Toledo" = "45",
    "Valencia/Valéncia" = "46",
    "Valladolid" = "47",
    "Bizkaia" = "48",
    "Zamora" = "49",
    "Zaragoza" = "50",
    "Ceuta" = "51",
    "Melilla" = "52"
  )

  census <-
    read_fst(processed_path, columns = columns_to_read) %>%
    mutate(CMUN = str_pad(CMUN, width = 3, pad = 0),
           NPRO = reverse_name(recode_prov)[CPRO],
           # CUMUN is the column with both the province code and
           # the municipality code. Province is two digit (e.g. 01)
           # and CMUN is three digits. The complete CUMUN is 01059
           CUMUN = paste0(CPRO, CMUN)) %>%
    as_tibble()

  all_shp <-
    read_sf(shp_file) %>%
    # Some municipalities are repeated twice because of a change in the accent
    # of a given letter. Here we harmonize.
    mutate_at(vars(NMUN, NPRO, NCA), stri_trans_general, id = "Latin-ASCII") %>%
    mutate(NPRO = gsub("Gipuzkoa", "Gipuzcoa", NPRO)) %>% 
    select(CUMUN, NMUN, NPRO, NCA) %>% 
    group_by(CUMUN, NMUN, NPRO, NCA) %>%
    summarize(n = n()) %>%
    ungroup()

  all_shp

  tst_census <-
    census %>%
    distinct(CUMUN) %>%
    mutate(available = 1)

  # Check which municipalities are available in the census
  # because many of them are anonymized
  tst_merge <-
    left_join(all_shp, tst_census, by = "CUMUN") %>%
    filter(available == 1)

  # This function should return a dataframe but I was exploring stuff
  # to see which municipalites are available. Don't try to loadd
  # or readd the cache from drake because it wont' return this plot.
  # This should be a data frame so the cache saves it as fst.
  plot(all_shp[0], reset = FALSE)
  plot(tst_merge[0], add = TRUE, col = "red")
}

read_census.census_2011 <- function(processed_path, shp_file, columns_to_read) {
  recode_prov <- c(
    "Araba/Álava" = "01",
    "Albacete" = "02",
    "Alicante/Alacant" = "03",
    "Almería" = "04",
    "Ávila" = "05",
    "Badajoz" = "06",
    "Balears, Illes" = "07",
    "Barcelona" = "08",
    "Burgos" = "09",
    "Cáceres" = "10",
    "Cádiz" = "11",
    "Castellón/Castelló" = "12",
    "Ciudad Real" = "13",
    "Córdoba" = "14",
    "Coruña, A" = "15",
    "Cuenca" = "16",
    "Girona" = "17",
    "Granada" = "18",
    "Guadalajara" = "19",
    "Gipuzkoa" = "20",
    "Huelva" = "21",
    "Huesca" = "22",
    "Jaén" = "23",
    "León" = "24",
    "Lleida" = "25",
    "Rioja, La" = "26",
    "Lugo" = "27",
    "Madrid" = "28",
    "Málaga" = "29",
    "Murcia" = "30",
    "Navarra" = "31",
    "Ourense" = "32",
    "Asturias" = "33",
    "Palencia" = "34",
    "Palmas, Las" = "35",
    "Pontevedra" = "36",
    "Salamanca" = "37",
    "Santa Cruz de Tenerife" = "38",
    "Cantabria" = "39",
    "Segovia" = "40",
    "Sevilla" = "41",
    "Soria" = "42",
    "Tarragona" = "43",
    "Teruel" = "44",
    "Toledo" = "45",
    "Valencia/Valéncia" = "46",
    "Valladolid" = "47",
    "Bizkaia" = "48",
    "Zamora" = "49",
    "Zaragoza" = "50",
    "Ceuta" = "51",
    "Melilla" = "52"
  )

  census <-
    read_fst(processed_path, columns = columns_to_read) %>%
    rename(NPRO = CPRO) %>%
    mutate(CMUN = str_pad(CMUN, width = 3, pad = 0),
           CPRO = recode_prov[NPRO],
           # CUMUN is the column with both the province code and
           # the municipality code. Province is two digit (e.g. 01)
           # and CMUN is three digits. The complete CUMUN is 01059
           CUMUN = paste0(CPRO, CMUN)) %>%
    as_tibble()


  all_shp <-
    read_sf(shp_file) %>%
    # Some municipalities are repeated twice because of a change in the accent
    # of a given letter. Here we harmonize.
    mutate_at(vars(NMUN, NPRO, NCA), stri_trans_general, id = "Latin-ASCII") %>%
    mutate(NPRO = gsub("Gipuzkoa", "Gipuzcoa", NPRO)) %>% 
    select(CUMUN, NMUN, NPRO, NCA) %>% 
    group_by(CUMUN, NMUN, NPRO, NCA) %>%
    summarize(n = n()) %>%
    ungroup()

  tst_census <-
    census %>%
    distinct(CUMUN) %>%
    mutate(available = 1)

  # Check which municipalities are available in the census
  # because many of them are anonymized
  tst_merge <-
    left_join(all_shp, tst_census, by = "CUMUN") %>%
    filter(available == 1)

  # This function should return a dataframe but I was exploring stuff
  # to see which municipalites are available. Don't try to loadd
  # or readd the cache from drake because it wont' return this plot.
  # This should be a data frame so the cache saves it as fst.
  plot(all_shp[0], reset = FALSE)
  plot(tst_merge[0], add = TRUE, col = "red")
}


reverse_name <- function (x) {
    stats::setNames(names(x), x)
}
