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

#' Translate the data object to the format expected by current template
#'
#' @param data input data object
#' @param opts options of current template
#' @return The opts variable with the opts$data variable filled in
translate <- function(data, opts) {
    library(rjson)
    data <- as.data.frame(data, stringsAsFactors=FALSE)
    translated_data <- prepare_data(data)
    translated_data <- toJSON(translated_data)
    opts$data <- translated_data
    opts
}

