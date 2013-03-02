library(df2json)

quote_for_json <- function(input) {
    paste0("\"", input, "\"")
}

write_input <- function(input, path){
    input <- as.data.frame(input, stringsAsFactors=FALSE)
    input <- df2json(input)
    writeLines(input, path)
}

translate <- function(input, opts) {
    write_input(input, opts$path$data_file)
    input_path <- quote_for_json(opts$path$data_file)
    input_path
}

