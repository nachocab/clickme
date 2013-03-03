prepare_data <- function(data){
    data <- lapply(levels(data$line), function(line){
        values <- apply(data[data$line == line, c("x","y")], 1, function(row){
            as.list(row)
        })
        names(values) <-  NULL
        list(key = line, values = values)
    })

    data
}

clickme_translate <- function(data, opts) {
    data <- as.data.frame(data, stringsAsFactors=FALSE)
    data <- prepare_data(data)
    data <- toJSON(data)
    data
}

