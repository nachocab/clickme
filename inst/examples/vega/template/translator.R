get_spec_path_param <- function(opts) {
    spec_path <- opts$params$spec_path
    if (is.null(spec_path)){
        if (!is.null(opts$params$spec)){
            spec_path <- file.path(opts$path$template, "spec", paste0(opts$params$spec, ".json"))
        } else {
            stop("Please provide a Vega spec name or path (ex: params = c(spec=\"area\") or params = c(spec_path=\"/path/to/spec.json\")")
        }
    }

    if (!file.exists(spec_path)){
        stop("No spec file was found at: ", spec_path)
    }

    spec_path
}

get_data_as_json <- function(opts) {
    library(df2json)
    data <- as.data.frame(opts$data, stringsAsFactors = FALSE)
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
    data <- as.data.frame(opts$params$event_data, stringsAsFactors = FALSE)
    json_data <- df2json(data)

    json_data
}

get_data_as_csv_file <- function(opts) {
    opts$data <- as.data.frame(opts$data, stringsAsFactors= FALSE)
    csv_file <- create_data_file(opts, "csv")

    csv_file
}


