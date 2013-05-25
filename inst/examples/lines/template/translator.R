get_data_as_json <- function(opts) {
    library(df2json)
    data <- as.data.frame(opts$data, stringsAsFactors = FALSE)
    json_data <- df2json(data)

    json_data
}

get_data_as_json_file <- function(opts) {
    opts$data <- as.data.frame(opts$data, stringsAsFactors= FALSE)
    opts$data <- get_data_as_json(opts)
    json_file <- create_data_file(opts, "json")

    json_file
}
