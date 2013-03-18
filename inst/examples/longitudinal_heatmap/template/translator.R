prepare_data <- function(data){
    data <- as.data.frame(data)

    if ("gene_symbol" %notin% colnames(data)){
        data$gene_symbol <- rownames(data)
    }

    if ("cluster" %notin% colnames(data)){
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
    data_file_name <- paste0(strsplit(opts$name$data_file, "\\.")[[1]][1], ".csv")

    write.table(data, file = file.path(opts$path$data, data_file_name), sep = ",", quote=FALSE, row.names=FALSE, col.names=TRUE)

    path <- paste0("\"", file.path(opts$relative_path$data, data_file_name), "\"")
    path
}
