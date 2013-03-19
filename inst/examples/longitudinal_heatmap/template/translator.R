prepare_data <- function(data){
    data <- as.data.frame(data)

    if (! "gene_symbol" %in% colnames(data)){
        data$gene_symbol <- rownames(data)
    }

    if (! "cluster" %in% colnames(data)){
        data$cluster <- 1
    }

    data
}

#' Translate the data object to the format expected by template.Rmd
#'
#' It returns the translated data object.
#'
#' @param data input data object
#' @param opts options of current ractive
translate <- function(data, opts) {
    data <- prepare_data(data)
    data_file_name <- paste0(opts$data_name, ".csv")
    data_file_path <- file.path(opts$path$data, data_file_name)
    relative_data_file_path <- file.path(opts$relative_path$data, data_file_name)

    write.table(data, file = data_file_path, sep = ",", quote=FALSE, row.names=FALSE, col.names=TRUE)
    message("Created data file at: ", data_file_path)

    path <- paste0("\"", relative_data_file_path, "\"")
    path
}
