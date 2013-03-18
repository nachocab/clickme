clickme_translate <- function(data, opts) {
    library(df2json)
    data <- as.data.frame(data, stringsAsFactors=FALSE)
    data <- df2json(data)
    data
}

