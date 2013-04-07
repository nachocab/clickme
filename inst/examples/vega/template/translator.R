get_spec_path_param <- function(opts) {
    spec_path <- opts$params$spec_path
    if (is.null(spec_path)){
        if (!is.null(opts$params$spec)){
            spec_path <- file.path(opts$path$data, "spec", paste0(opts$params$spec, ".json"))
        } else {
            stop("Please provide a Vega spec name or path (ex: params=list(spec=\"area\") or params=list(spec_path=\"/path/to/spec.json\")")
        }
    }

    if (!file.exists(spec_path)){
        stop("No spec file was found at: ", spec_path)
    }

    spec_path
}

get_padding_param <- function(opts, default = c(top = 10, left = 30, bottom = 30, right = 10)) {
    if (is.null(opts$params$padding)){
        opts$params$padding <- default
    }

    library(rjson)
    padding <- opts$params$padding

    if (length(padding) != 4){
        stop("Please provide four padding values. (currently ", paste(padding, collapse=", "), ")")
    }

    if (is.null(names(padding))) {
        names(padding) <- c("top", "left", "bottom", "right")
    }

    padding <- toJSON(padding)

    padding
}

get_data_as_json <- function(opts) {
    library(df2json)
    data <- as.data.frame(opts$data, stringsAsFactors=FALSE)
    json_data <- df2json(data)

    json_data
}

get_data_as_json_file <- function(opts) {
    opts$data <- get_data_as_json(opts)
    json_file <- create_data_file(opts, "json")

    json_file
}

get_event_data_param <- function(opts) {
    library(df2json)
    data <- as.data.frame(opts$params$event_data, stringsAsFactors=FALSE)
    json_data <- df2json(data)

    json_data
}

get_data_as_csv_file <- function(opts) {
    opts$data <- as.data.frame(opts$data, stringsAsFactors= FALSE)
    csv_file <- create_data_file(opts, "csv")

    csv_file
}


