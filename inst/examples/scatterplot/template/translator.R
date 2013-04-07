get_padding_param <- function(opts, default = c(top = 10, left = 30, bottom = 30, right = 10)) {
    if (is.null(opts$params$padding)){
        opts$params$padding <- default
    }

    library(rjson)
    padding <- opts$params$padding

    if (length(padding) != 5){
        stop("Please provide four padding values and a scale. (currently ", paste(padding, collapse=", "), ")")
    }

    if (is.null(names(padding))) {
        names(padding) <- c("top", "left", "bottom", "right", "scale")
    }

    padding <- toJSON(padding)

    padding
}

get_data_as_json <- function(opts) {
    library(df2json)
    data <- as.data.frame(opts$data, stringsAsFactors=FALSE)

    if (is.null(data$group)) data$group <- ""
    if (is.null(data$name)) data$name <- rownames(data)

    json_data <- df2json(data)

    json_data
}

get_data_as_json_file <- function(opts) {
    opts$data <- get_data_as_json(opts)
    json_file <- create_data_file(opts, "json")

    json_file
}
