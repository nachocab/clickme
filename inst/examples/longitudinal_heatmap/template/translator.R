coerce_names <- function(data){
    if (!"gene_symbol" %in% colnames(data)){
        data$gene_symbol <- rownames(data)
    }

    if (!"cluster" %in% colnames(data)){
        data$cluster <- 1
    }

    data
}

get_data_as_csv_file <- function(opts) {
    opts$data <- as.data.frame(opts$data, stringsAsFactors= FALSE)
    opts$data <- coerce_names(opts$data)
    csv_file <- create_data_file(opts, "csv")

    csv_file
}
