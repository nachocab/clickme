#'
#'
#' Depending on the template, the columns of data will be renamed one way or another, which minimizes the time from idea to implementation.
prepare_data <- function(data, template){
    data <- as.data.frame(data, stringsAsFactors=FALSE)
    if (template == "scatterplot" | template == "scatterplot_canvas"){
        scatterplot_numeric_columns <- c("x","y")
        scatterplot_character_columns <- c("name")

        data_numeric_columns <- names(sapply(data, is.numeric))
        if (length(data_numeric_columns) < length(scatterplot_numeric_columns)) stop(paste("Data should have at least", length(scatterplot_numeric_columns), "numeric columns"))

        if ("x" %notin% colnames(data)) {
            # rename the first numeric column that isn't in data_numeric_columns
            data_numeric_columns <- names(data[,sapply(data, is.numeric),drop=FALSE])
            data_numeric_columns <- data_numeric_columns[data_numeric_columns %notin% scatterplot_numeric_columns]
            colnames(data)[colnames(data)==data_numeric_columns[1]] <- "x"
        }
        if ("y" %notin% colnames(data)) {
            # rename the first numeric column that isn't in data_numeric_columns
            data_numeric_columns <- names(data[,sapply(data, is.numeric),drop=FALSE])
            data_numeric_columns <- data_numeric_columns[data_numeric_columns %notin% scatterplot_numeric_columns]
            colnames(data)[colnames(data)==data_numeric_columns[1]] <- "y"
        }

        data_character_columns <- names(data[,sapply(data, is.character),drop=FALSE])
        if (length(data_character_columns) >= length(scatterplot_character_columns)){
            # there is a "name" column
            if ("name" %notin% colnames(data)) {
                data_character_columns <- data_character_columns[data_character_columns %notin% scatterplot_numeric_columns]
                colnames(data)[colnames(data)==data_character_columns[1]] <- "name"
            }
        } else {
            # there is no "name" column, get it from rownames if available, otherwise generate it
            if (is.null(rownames(data))){
                rownames(data) <- seq(1:nrow(data))
            }
            data$name <- rownames(data)
        }

    }

    data
}