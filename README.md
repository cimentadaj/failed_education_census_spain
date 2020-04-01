# Failed education in Spain

This repository hosts the work of a paper exploring failed education in Spain using census data. The repo is named after **f**ailed **e**ducation **spain**.

1. Clone the repository in your local computer either by `git clone https://github.com/cimentadaj/fespain.git` or by clicking on `Clone or download` (the green button on Github) and then clicking on `Download ZIP`. For those who downloaded the zipped project, unzip it in your local computer.

2. Navigate to the root of the repository and open an R session there

3. Download several Spanish censuses.

  1. Spanish 1991 census data from [here](https://www.ine.es/censos2011_datos/cen11_datos_microdatos.htm). Click on 'Censos 1991' --> go to the section 'Personas' -> search for the phrase 'Ficheros de microdatos (muestra 10%). Seleccionar provincia:' in this section --> iteratively choose each province and then click on 'Ir' to download the data. You need to do this for each province, download the zip file to `raw_data/censo_1991/provincias` and leave it **unzipped**. This way, you'll get 52 files, one for each province. In R, you can download everything automatically with the code below. **NOTE**: This assumes that the working directory in R is the root of the repository.

  ```r
  # Provide here the directory where you would like to save all province files
  where_to_save <- file.path(".", "raw_data", "censo_1991", "provincias")

  prov_paths <-
    paste0("ftp://www.ine.es/temas/censopv/cen91_p/p",
           formatC(1:52, width = "2", flag = "0"),
           "mper_cen91.zip")
  
  for (i in prov_paths) {
    dir_save <- file.path(where_to_save, basename(i))
    download.file(i, dir_save)
  }

```

  All files should be saved now in `raw_data/censo_1991/provincias`

  2. Spanish 2001 census data from [here](https://www.ine.es/censos2011_datos/cen11_datos_microdatos.htm). Click on 'Censos 2001' --> go to the section 'Personas y hogares' -> search for the phrase 'Fichero de microdatos por provincias' in this section --> iteratively choose each province and then click on 'Ir' to download the data. You need to do this for each province, download the zip file to `raw_data/censo_2001/provincias` and leave it **unzipped**. This way, you'll get 52 files, one for each province. In R, you can download everything automatically with the code below. **NOTE**: This assumes that the working directory in R is the root of the repository.
  
```r
  # Provide here the directory where you would like to save all province files
  where_to_save <- file.path(".", "raw_data", "censo_2001", "provincias")
  
  prov_paths <-
    paste0("ftp://www.ine.es/temas/censopv/cen01_ph/p",
           formatC(1:52, width = "2", flag = "0"),
           "ph_cen01.zip")

  for (i in prov_paths) {
    dir_save <- file.path(where_to_save, basename(i))
    download.file(i, dir_save)
  }
  
```

  All files should be saved now in `raw_data/censo_2001/provincias`

  3. Spanish 2011 census data from [here](https://www.ine.es/censos2011_datos/cen11_datos_microdatos.htm) (click on 'Nacional' after 'Fichero de microdatos' and a download window should appear). Download the data and save the zip file in the folder `raw_data/censo_2011`. The zip file should weight around 155MB. In R, you can downloading everything automatically with the code below (can take a while).  **NOTE**: This assumes that the working directory in R is the root of the repository.
  
```r
# Provide here the directory where you would like to save all province files
where_to_save <- file.path(".", "raw_data", "censo_2011")
paths <- "ftp://www.ine.es/temas/censopv/cen11/Microdatos_personas_nacional.zip"
dir_save <- file.path(where_to_save, basename(paths))
download.file(paths, dir_save)
```

Note that running the whole analysis requires your computer to have more than 8 GB of RAM as the data is quite heavy. If any errors arise out of lack of memory, you need to run this in a computer with more RAM memory.

<!-- 3. Open an R session on the root of the project and run in R `install.packages("renv")`, then run `renv::init()` and when prompted by the console, choose `1: Restore the project from the lockfile.` by pressing the number `1`. -->

4. Restart R in the root directory and you should see something like this on the top of your screen:

```
* Project '~/repositories/fespain' loaded. [renv 0.5.0-66]
```

Doesn't matter if the directory is not the same. It's alright if you got **something** like this.

Now run `renv::init()` and when prompted by the console, choose `1: Restore the project from the lockfile.` by pressing the number `1`.

At this point you should have all the code of the project and the packages needed to run it.

5. Restart R in the same root directory and run `drake::r_make()` from the R console. All of the analysis should start compiling.
