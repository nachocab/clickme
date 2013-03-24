#' Translate the data object to the format expected by current template
#'
#' It returns the translated data object.
#'
#' @param data input data object
#' @param opts options of current template
translate <- function(data, opts=NULL) {
    library(ape)
    if (class(data) == "phylo"){
        data <- write.tree(data)
    }  else if (file.exists(data)) {
        data <- scan(data, "character")
    }
    data
}
