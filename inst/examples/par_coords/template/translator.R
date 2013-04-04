get_color_by_param <- function(opts) {
    if (is.null(opts$params$color_by)){
        column_types <- unlist(lapply(as.list(opts$data), function(x) class(x)))
        first_numeric_column <- names(column_types[column_types == "numeric"])[1]
        opts$params$color_by <- first_numeric_column
    } else if (opts$params$color_by %notin% colnames(opts$data)){
        stop("The input data doesn't contain a column named: ", opts$params$color_by)
    }

    opts$params$color_by
}

get_domain_param <- function(opts){
    if (is.null(opts$params$domain)){
        opts$params$domain <- range(opts$data[, get_color_by_param(opts)])
    }
    opts$params$domain <- paste(opts$params$domain, collapse=", ")

    opts$params$domain
}

get_data_as_csv_file <- function(opts) {
    csv_file <-  create_data_file(opts, "csv")

    csv_file
}
