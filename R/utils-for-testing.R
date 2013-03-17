#' return a filled matrix
mat <- function(elements=NULL, num_elements=nrow*ncol, nrow=5, ncol=2, scale_by=100, rownames=NULL, colnames=NULL){
    if (is.null(elements)){
        elements <- runif(num_elements) * scale_by
    }
    if (!is.null(ncol)){
        mat <- matrix(elements, ncol=ncol, byrow=T)
    } else {
        mat <- matrix(elements, nrow=nrow, byrow=T)
    }

    if (!is.null(rownames)) rownames(mat) <- rownames
    if (!is.null(colnames)) colnames(mat) <- colnames

    mat
}

#' Remove files in path
cleanup_files <- function(path, files=NULL) {
    if (is.null(files)){
        unlink(path, recursive=TRUE)
    } else {
        sapply(files, function(file){
            unlink(file.path(path, file), recursive=TRUE)
        })
    }
}