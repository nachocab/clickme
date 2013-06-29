is.valid <- function(x){
    !is.na(x) & !is.nan(x) & !is.infinite(x)
}

quote_for_JSON <- function(element){
    paste0("\"", element, "\"")
}

translate_to_JSON <- function(value){
    if (!is.valid(value)){
        value <- "null"
    } else if (is.logical(value)){
        value <- if (value)  "true" else "false"
    } else if (is.character(value)){
        value <- quote_for_JSON(value)
    } else if (is.factor(value)){
        value <- quote_for_JSON(as.character(value))
    } else {
        # numeric, don't do anything
    }

    value
}

prepare_for_JSON <- function(data){
    data <- lapply(colnames(data), function(key){
        sapply(data[, key], function(value){
            key <- quote_for_JSON(key)
            value <- translate_to_JSON(value)
            paste0(key, ':', value)
        })
    })
    as.data.frame(data, stringsAsFactors = FALSE)
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
    df <- prepare_for_JSON(df)
    objects <- apply(df, 1, function(row) {paste(row, collapse = ',')})
    objects <- paste0('{', objects, '}')
    objects <- paste0('[', paste(objects, collapse = ',\n'), ']')

    objects
}

#' Convert a matrix to JSON
#'
#' It returns a string of nested arrays. One array per row.
#'
#' @param mat input matrix object
#' @export
#' @import rjson
#' @examples library(df2json)
#' df <- matrix(1:9, byrow = TRUE, nrow=3)
#' matrix2json(df)
matrix2json <- function(mat){
    mat <- as.list(as.data.frame(t(mat), stringsAsFactors = FALSE))
    names(mat) <- NULL
    json <- toJSON(mat)
    json
}

#' Convert a JSON string into a data frame
#'
#' @param json input json object
#' @export
#' @import rjson
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
#' @import rjson
#' @examples library(df2json)
#' yaml <- "- a: 1.0\n  b: 2.0\n- a: 3.0\n  b: 4.0\n"
#' yaml2df(json)
yaml2df <- function(yaml){
    json2df(toJSON(yaml))
}


#' Convert a string to JSON
#'
#' @param x input object
#' @export
to_json <- function(x){
    rjson::toJSON(x)
}