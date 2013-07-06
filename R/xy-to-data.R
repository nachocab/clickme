#' Generate appropriate rownames for an object
#'
#' @param x data object
#'
get_xy_rownames <- function(x) {
    UseMethod("get_xy_rownames", x)
}

#' @S3method get_xy_rownames data.frame
get_xy_rownames.data.frame <- function(x) {
  if (!is.null(rownames(x))){
      rownames <- rownames(x)
  } else {
      rownames <- as.character(1:nrow(x))
  }
  rownames
}

#' @S3method get_xy_rownames matrix
get_xy_rownames.matrix <- function(x){
    get_xy_rownames.data.frame(x)
}

#' @S3method get_xy_rownames character
get_xy_rownames.character <- function(x){
    if (!is.null(names(x)) && !any(duplicated(names(x)))) {
        rownames <- names(x)
    } else {
        rownames <- as.character(1:length(x))
    }
    rownames
}

#' @S3method get_xy_rownames default
get_xy_rownames.default <- function(x) {
    get_xy_rownames.character(x)
}

# Convert x and y into a data.frame object with x, y and row names.
#' @export
xy_to_data <- function(x, y) {
    if (is_character_or_factor(x) && is.null(y)){
        stop("y cannot be NULL when x is a character vector or a factor")
    }

    if (is_data_frame_or_matrix(x)){
        if (ncol(x) < 2){
            stop("When x is a dataframe or a matrix, it must contain at least two columns")
        } else if (ncol(x) == 2) {
            data_x <- x[, 1]
            data_y <- x[, 2]
            rownames <- get_xy_rownames(x)
        } else if (ncol(x) > 2 && is.numeric(as.matrix(x))){
            data_x <- rep(colnames(x), each = nrow(x))
            data_y <- as.vector(as.matrix(x))
            rownames <- get_xy_rownames(data_x)
        } else {
            message("\n\tx is not numeric and it has more than two columns, using the first two: ", paste(colnames(x)[1:2], collapse = ", "), "\n")
            data_x <- x[, 1]
            data_y <- x[, 2]
            rownames <- get_xy_rownames(x)
        }
    } else if (is.list(x)) {
        if (length(x) < 2) stop("When x is a list, it must contain at least two elements")

        if (length(x[[1]]) != length(x[[2]])) stop("The first two elements of x have different lengths")

        data_x <- x[[1]]
        data_y <- x[[2]]
        rownames <- get_xy_rownames(data_x)
    } else {
        if (is.null(y)){
            data_x <- 1:length(x)
            data_y <- x
            rownames <- get_xy_rownames(x)
        } else {
            if (is_data_frame_or_matrix(y)){
                if (length(x) != ncol(y)) {
                    stop(gettextf("x has %d elements, but y has %d columns", length(x), ncol(y)))
                }
                data_x <- rep(x, each = nrow(y))
                data_y <- as.vector(as.matrix(y))
                rownames <- get_xy_rownames(data_x)
            } else {
                if (length(x) != length(y)){
                    stop(gettextf("x has %d elements, but y has %d", length(x), length(y)))
                }

                data_x <- x
                data_y <- y
                rownames <- get_xy_rownames(x)
            }
        }
    }

    data <- data.frame(x = data_x, y = data_y, row.names = rownames, stringsAsFactors = FALSE)

    data
}