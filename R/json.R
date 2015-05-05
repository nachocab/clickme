#' Convert a string to JSON
#'
#' @param x input object
#' @export
to_json <- function(x) {
    UseMethod("to_json", x)
}

#' @export to_json
to_json.array <- function(x){
    if (length(x) > 1){
        json <- to_json.default(x)
    } else {
        json <- to_monovector(x)
    }

    json
}

#' @export to_json
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

#' @export to_json
to_json.list <- function(x){
    json <- rjson::toJSON(x)
    json
}

#' @export to_json
to_json.factor <- function(x){
    if (length(x) > 1){
        json <- rjson::toJSON(x)
    } else {
        json <- to_monovector(x)
    }
    json
}

#' @export to_json
to_json.data.frame <- function(x){
    if (length(x)){
        x <- prepare_for_json(x)
        json <- apply(x, 1, function(row) {paste(row, collapse = ',')})
        json <- sprintf('{%s}', json)
        json <- sprintf('[%s]', paste(json, collapse = ',\n'))
    } else {
        json <- "[]"
    }

    json
}

#' @export to_json
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
    if (!length(x) || is.na(x)){
        x <- ""
    } else if (is.character(x) || is.factor(x)){
        x <- deparse(as.character(x))
    }
    monovector <- sprintf("[%s]", x)
    monovector
}


# Convert each value in the dataframe to character
# and prepend the "\"key\":"
# prepend the key name to each value in the dataframe "key":value
prepare_for_json <- function(x){
    x <- lapply(colnames(x), function(key){
        sapply(x[, key], function(value){
            key <- deparse(key)
            if (is.factor(value))
                value <- as.character(value)
            value <- to_json(value)
            sprintf("%s:%s", key, value)
        })
    })
    as.data.frame(x, stringsAsFactors = FALSE)
}

#' Convert a JSON string into a data frame
#'
#' @param json input json object
# "[{\"a\":1, \"b\":2},{\"a\":3,\"b\":4}]"
#' @export
json2df <- function(json){
    json <- fromJSON(json)
    df <- do.call(rbind.data.frame, json)
    rownames(df) <- NULL

    df
}

#' Convert a YAML string into a data frame
#'
#' @param yaml input yaml object
# yaml <- "- a: 1.0\n  b: 2.0\n- a: 3.0\n  b: 4.0\n"
#' @export
yaml2df <- function(yaml){
    json2df(toJSON(yaml))
}