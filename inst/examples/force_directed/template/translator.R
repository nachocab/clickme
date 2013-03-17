clickme_translate <- function(data, opts) {
    data <- as.data.frame(data, stringsAsFactors=FALSE)
    data <- df2json(data)
    data
}

