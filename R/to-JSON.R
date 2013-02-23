is.valid <- function(x){
    !is.na(x) & !is.nan(x) & !is.infinite(x)
}

quote_for_JSON <- function(element){
    paste0("\"", element, "\"")
}

prepare_for_JSON <- function(data){
    data <- lapply(colnames(data), function(key){
        sapply(data[, key], function(value){
            if (!is.valid(value)){
                value <- quote_for_JSON("null")
            }
            else if (is.logical(value)){
                value <- if (value)  "true" else "false"
            }
            else if (is.character(value)){
                value <- quote_for_JSON(value)
            } else if (is.factor(value)){
                value <- quote_for_JSON(as.character(value))
            }
            paste0(quote_for_JSON(key), ':', value)
        })
    })
    as.data.frame(data)
}

to_JSON <- function(data){
    data <- prepare_for_JSON(data)
    objects <- apply(data, 1, function(row) {paste(row, collapse = ',')})
    objects <- paste0('{', objects, '}')
    objects <- paste0('[', paste(objects, collapse = ',\n'), ']')

    objects
}