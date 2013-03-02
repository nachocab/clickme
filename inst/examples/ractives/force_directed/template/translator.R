library(df2json)

translate <- function(input, opts) {
    input <- as.data.frame(input, stringsAsFactors=FALSE)
    input <- df2json(input)
    input
}

