get_data_as_json <- function(opts) {
    library(df2json)
    data <- as.data.frame(opts$data, stringsAsFactors = FALSE)
    json_data <- df2json(data)

    json_data
}

