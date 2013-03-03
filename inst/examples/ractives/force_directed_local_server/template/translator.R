library(df2json)

quote_for_json <- function(data) {
    paste0("\"", data, "\"")
}

write_json <- function(data, path){
    data <- df2json(data)
    writeLines(data, path)
}

clickme_translate <- function(data, opts) {
    data <- as.data.frame(data, stringsAsFactors=FALSE)
    write_json(data, opts$path$data_file)
    data_path <- quote_for_json(opts$path$data_file)
    data_path
}

