get_padding_param <- function(opts) {
    library(rjson)
    padding <- opts$params$padding

    if (length(padding) != 4){
      cat("length(padding): ", length(padding), "\n")
        stop("Please provide four padding values and a scale. (currently ", paste(padding, collapse=", "), ")")
    }

    if (is.null(names(padding))) {
        names(padding) <- c("top", "left", "bottom", "right")
    }

    padding <- toJSON(padding)

    padding
}

get_data_as_json <- function(opts) {
    library(df2json)
    data <- as.data.frame(opts$data, stringsAsFactors = FALSE)

    if (is.null(data$group)) data$group <- ""
    if (is.null(data$name)) data$name <- rownames(data)

    json_data <- df2json(data)

    json_data
}

get_data_as_json_file <- function(opts) {
    opts$data <- as.data.frame(opts$data, stringsAsFactors= FALSE)
    opts$data <- get_data_as_json(opts)
    json_file <- create_data_file(opts, "json")

    json_file
}
