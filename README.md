# Failed education in Spain

This repository hosts the work of a paper exploring failed education in Spain using census data. The repo is named after **f**ailed **e**ducation **spain**.

1. To reproduce this, you'll need to download the Spanish 2011 census data from [here](https://www.ine.es/censos2011_datos/cen11_datos_microdatos.htm) (click on 'Nacional' after 'Fichero de microdatos' and a download window should appear). Once you download the data, save the file `MicrodatosCP_NV_per_nacional_3VAR.txt` in the `data` folder. Your `data` folder should only have the files `MicrodatosCP_NV_per_nacional_3VAR.txt` and `variable_labels.xls`, which already should be there.

Note that running this analysis requires your computer to have more than 8 GB of RAM as the data is quite heavy. If any errors arise out of lack of memory, you need to run this in a computer with more RAM memory.

2. Clone the repository in your local computer either by `git clone https://github.com/cimentadaj/fespain.git` or by clicking on `Clone or download` (the green button on Github) and then clicking on `Download ZIP`. For those who downloaded the zipped project, unzip it in your local computer.

<!-- 3. Open an R session on the root of the project and run in R `install.packages("renv")`, then run `renv::init()` and when prompted by the console, choose `1: Restore the project from the lockfile.` by pressing the number `1`. -->

3. Restart R in the root directory and you should see something like this on the top of your screen:

```
* Project '~/repositories/fespain' loaded. [renv 0.5.0-66]
```

Doesn't matter if the directory is not the same. It's alright if you got **something** like this.

Now run `renv::init()` and when prompted by the console, choose `1: Restore the project from the lockfile.` by pressing the number `1`.

At this point you should have all the code of the project and the packages needed to run it.

5. Restart R in the same root directory and run `drake::r_make()` from the R console. All of the analysis should start compiling.
