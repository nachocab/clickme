get_data_as_json <- function(opts) {
    library(df2json)
    opts$data <- as.data.frame(opts$data, stringsAsFactors=FALSE)
    json_data <- df2json(opts$data)

    json_data
}

