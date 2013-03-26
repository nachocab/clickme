
coerce_parameters <- function(data, opts){
    if (is.null(opts$params$color_by)){
        column_types <- unlist(lapply(as.list(data), function(x) class(x)))
        first_numeric_column <- names(column_types[column_types == "numeric"])[1]
        opts$params$color_by <- first_numeric_column
    } else if (opts$params$color_by %notin% colnames(data)){
        stop("The input data doesn't contain a column named: ", opts$params$color_by)
    }
    if (is.null(opts$params$range)){
        opts$params$range <- range(data[, opts$params$color_by])
    }

    opts$params$range <- paste(opts$params$range, collapse=", ")
    opts
}

#' Translate the data object to the format expected by current template
#'
#' @param data input data object
#' @param opts options of current template
#' @return The opts variable with the opts$data variable filled in
translate <- function(data, opts) {
    opts <- coerce_parameters(data, opts)

    data_file_name <- paste0(opts$data_name, ".csv")
    data_file_path <- file.path(opts$path$data, data_file_name)
    relative_data_file_path <- file.path(opts$relative_path$data, data_file_name)

    write.table(data, file = data_file_path, sep = ",", quote=FALSE, row.names=FALSE, col.names=TRUE)
    message("Created data file at: ", data_file_path)

    opts$data <- paste0("\"", relative_data_file_path, "\"")
    opts
}
