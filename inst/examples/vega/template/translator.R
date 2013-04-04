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

get_padding_param <- function(opts) {
    library(rjson)
    padding <- opts$params$padding
    if (is.null(padding)){
        padding <- c(top = 10, left = 30, bottom = 30, right = 10)
    }

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
  if (class(opts$data) =="data.frame") {
    library(df2json)
    json_data <- df2json(opts$data)
  } else {
    library(rjson)
    json_data <- toJSON(opts$data)    
  }
    json_data
}

get_data_as_json_file <- function(opts) {
    opts$data <- get_data_as_json(opts)
    json_file <- create_data_file(opts, "json")

    json_file
}
