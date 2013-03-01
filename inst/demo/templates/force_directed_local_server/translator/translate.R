library(df2json)

quote_for_json <- function(input) {
    paste0("\"", input, "\"")
}

translate <- function(input, opts) {
    input <- as.data.frame(input, stringsAsFactors=FALSE)
    input <- df2json(input)

    input_path <- file.path(opts$path$template_id, paste0(opts$name$data_file, ".json"))
    writeLines(input, input_path)

    input_path <- quote_for_json(file.path(opts$name$data, paste0(opts$name$data_file, ".json")))
    input_path
}

