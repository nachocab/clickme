prepare_data <- function(data){
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

#' Translate the data object to the format expected by template.Rmd
#'
#' It returns the translated data object.
#'
#' @param data input data object
#' @param opts options of current ractive
translate <- function(data, opts) {
    library(rjson)
    data <- as.data.frame(data, stringsAsFactors=FALSE)
    data <- prepare_data(data)
    data <- toJSON(data)
    data
}

