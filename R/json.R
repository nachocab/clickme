#' Convert a string to JSON
#'
#' @param x input object
#' @export
to_json <- function(x) {
    UseMethod("to_json", x)
}

#' @S3method to_json array
to_json.array <- function(x){
    if (length(x) > 1){
        json <- to_json.default(x)
    } else {
        json <- to_monovector(x)
    }

    json
}

#' @S3method to_json matrix
to_json.matrix <- function(x){
    if (length(x) > 1){
        x <- as.list(as.data.frame(t(x), stringsAsFactors = FALSE))
        names(x) <- NULL
        json <- to_json(x)
    } else {
        json <- to_monovector(x)
    }

    json
}

#' @S3method to_json list
to_json.list <- function(x){
    json <- rjson::toJSON(x)
    json
}

#' @S3method to_json factor
to_json.factor <- function(x){
    if (length(x) > 1){
        json <- rjson::toJSON(x)
    } else {
        json <- to_monovector(x)
    }
}

#' @S3method to_json data.frame
to_json.data.frame <- function(x){
    x <- prepare_for_json(x)
    json <- apply(x, 1, function(row) {paste(row, collapse = ',')})
    json <- paste0('{', json, '}')
    json <- paste0('[', paste(json, collapse = ',\n'), ']')

    json
}

#' @S3method to_json default
to_json.default <- function(x) {
    if (is.null(x)){
        json <- "null"
    } else if (length(x) > 0 && is.na(x)){
        json <- "NaN"
    } else if (length(x) > 0 && is.infinite(x)){
        json <- ifelse(x > 0, "Infinity", "-Infinity")
    } else {
        json <- rjson::toJSON(x)
    }

    json
}

to_monovector <- function(x){
    if (is.character(x) || is.factor(x)){
        x <- deparse(as.character(x))
    }
    monovector <- gettextf("[%s]", x)
    monovector
}


prepare_for_json <- function(x){
    x <- lapply(colnames(x), function(key){
        sapply(x[, key], function(value){
            key <- deparse(key)
            value <- to_json(value)
            paste0(key, ':', value)
        })
    })
    as.data.frame(x, stringsAsFactors = FALSE)
}


#' Convert a data frame to JSON
#'
#' It returns a string that contains an array of objects. There are as many JS objects as there are rows in the data frame. The column names are used as the keys of each object. The objects are separated by newlines.
#'
#' @param df input dataframe object
#' @export
#' @examples
#' df <- data.frame(name=c("a", "b", "c"), x=c(NA, 2 ,3), y=c(10, 20, -Inf), show=c(TRUE, FALSE, TRUE))
#' df2json(df)
df2json <- function(df){

}

#' Convert a matrix to JSON
#'
#' It returns a string of nested arrays. One array per row.
#'
#' @param mat input matrix object
#' @export
#' @examples library(df2json)
#' df <- matrix(1:9, byrow = TRUE, nrow=3)
#' matrix2json(df)
matrix2json <- function(mat){

    json <- toJSON(mat)
    json
}

#' Convert a JSON string into a data frame
#'
#' @param json input json object
#' @export
#' @examples library(df2json)
#' json <- "[{\"a\":1, \"b\":2},{\"a\":3,\"b\":4}]"
#' json2df(json)
json2df <- function(json){
    json <- fromJSON(json)
    df <- do.call(rbind.data.frame, json)
    rownames(df) <- NULL

    df
}

#' Convert a YAML string into a data frame
#'
#' @param yaml input yaml object
#' @export
#' @examples library(df2json)
#' yaml <- "- a: 1.0\n  b: 2.0\n- a: 3.0\n  b: 4.0\n"
#' yaml2df(json)
yaml2df <- function(yaml){
    json2df(toJSON(yaml))
}