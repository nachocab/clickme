#' Translate the data object to the format expected by template.Rmd
#'
#' It returns the translated data object.
#'
#' @param data input data object
#' @param opts options of current ractive
translate <- function(data, opts) {
    library(df2json)
    data <- as.data.frame(data, stringsAsFactors=FALSE)
    data <- df2json(data)
    data
}

