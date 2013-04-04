get_data_as_tree <- function(opts) {
    library(ape)
    if (class(opts$data) == "phylo"){
        tree_data <- write.tree(opts$data)
    }  else if (file.exists(opts$data)) {
        tree_data <- paste(readLines(opts$data), collapse = "\n")
    } else {
        tree_data <- opts$data
    }

    tree_data
}
