get_data_as_nested_structure <- function(data){
    if (!is.factor(data$line)) data$line <- as.factor(data$line)

    data <- lapply(levels(data$line), function(line){
        values <- apply(data[data$line == line, c("x","y")], 1, function(row){
            as.list(row)
        })
        names(values) <-  NULL
        list(key = line, values = values)
    })

    data
}

get_data_as_json <- function(opts) {
    library(rjson)
    data <- as.data.frame(opts$data, stringsAsFactors = FALSE)
    data <- get_data_as_nested_structure(data)
    json_data <- toJSON(data)

    json_data
}

