#' Translate the data object to the format expected by the current template
#'
#' It returns the translated data object.
#'
#' @param data input data object
#' @param opts options used by current template
translate <- function(data, opts = NULL) {
    library(df2json)
    data <- as.data.frame(data, stringsAsFactors=FALSE)
    data <- df2json(data)
    data
}

