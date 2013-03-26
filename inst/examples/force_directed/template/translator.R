#' Translate the data object to the format expected by current template
#'
#' @param data input data object
#' @param opts options of current template
#' @return The opts variable with the opts$data variable filled in
translate <- function(data, opts = NULL) {
    library(df2json)
    data <- as.data.frame(data, stringsAsFactors=FALSE)
    translated_data <- df2json(data)

    opts$data <- translated_data
    opts
}

