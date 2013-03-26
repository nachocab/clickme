#' Translate the data object to the format expected by current template
#'
#' @param data input data object
#' @param opts options of current template
#' @return The opts variable with the opts$data variable filled in
translate <- function(data, opts) {
    library(ape)
    if (class(data) == "phylo"){
        translated_data <- write.tree(data)
    }  else if (file.exists(data)) {
        translated_data <- scan(data, "character")
    } else {
        translated_data <- data
    }

    opts$data <- translated_data
    opts
}
