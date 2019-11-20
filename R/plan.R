data_path <- here("data", "MicrodatosCP_NV_per_nacional_3VAR.txt")
labels_path <- here("data", "variable_labels.xls")

plan <-
  drake_plan(
    read_data = target(read_census(data_path), format = "fst"),
    read_codebook = read_codebook_labels(file_in(labels_path)),
    process_data = target(select_few(read_data), format = "fst")
  )
