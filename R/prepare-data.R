rename_columns <- function(data, columns_of_type, requirement) {

    columns_to_rename <- which(colnames(data) %in% columns_of_type[1:length(requirement)] & colnames(data) %notin% requirement)
    rename_with <- requirement[requirement %notin% colnames(data)]
    colnames(data)[columns_to_rename] <- rename_with

    data
}

#' Ensure that data has the column names specified in template config
#'
#' clickme will do its best to rename data columns specified as required in the template_config file
#' if their names are missing. Optional columns will not be used unless the specified name matches the template_config name.
#' This ensures that data can be easily plotted without having to manually rename columns to match the config spec.
check_names <- function(data, template_config) {
    data <- as.data.frame(data, stringsAsFactors=FALSE)

    columns_of_type <- list()
    columns_of_type$numeric <- names(data[,sapply(data, is.numeric), drop=FALSE])
    columns_of_type$character <- names(data[, sapply(data, function(x) is.character(x) || is.factor(x)), drop=FALSE])
    columns_of_type$logical <- names(data[, sapply(data, is.logical), drop=FALSE])

    # deal with numeric
    if (length(columns_of_type$numeric) < length(template_config$required$numeric)) {
        stop(paste("Data should have at least", length(template_config$required$numeric), "numeric columns"))
    } else {
        data <- rename_columns(data, columns_of_type$numeric, template_config$required$numeric)
    }

    # deal with logical
    if (length(columns_of_type$logical) < length(template_config$required$logical)) {
        stop(paste("Data should have at least", length(template_config$required$logical), "logical columns"))
    } else {
        data <- rename_columns(data, columns_of_type$logical, template_config$required$logical)
    }

    # deal with character, I'm not too happy with this solution
    missing_character_columns <- template_config$required$character[template_config$required$character %notin% colnames(data)]
    if (length(missing_character_columns) == 1){
        # if there is only one character column missing, use the row names
        data[missing_character_columns] <- rownames(data)
    } else if (length(missing_character_columns) > 1){
        stop(paste("Data should have at least", length(template_config$required$character), "character columns"))
    }

    data
}

#' @import rjson
prepare_data <- function(data, template_config){
    if (is.matrix(data) || is.data.frame(data)){
        prepare_data_dataframe(data, template_config)
    } else {
        toJSON(data)
    }
}

#' Check data column names and convert to JSON
#'
#'
prepare_data_dataframe <- function(data, template_config){
    data <- check_names(data, template_config)
    data <- dataframe_to_JSON(data)
    data
}