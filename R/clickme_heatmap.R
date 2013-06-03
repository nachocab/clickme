get_col_values <- function(data, data_col_names, params){
    col_values <- unname(apply(data, 1, function(row){
        row_values <- lapply(1:length(row), function(row_index){
            # TODO: decided which of these versions you want
            # list(cell_value = unname(row[row_index]), row_name = rownames(data)[row_index], col_name = data_col_names[row_index])
            list(cell_value = unname(row[row_index]))
        })
        if (is.null(params$row_groups)){
            list(row_values = row_values)
        } else {
            list(row_values = row_values, row_group = params$row_groups[row_index])
        }
    }))

    col_values
}

format_heatmap_data <- function(data, data_col_names, params) {
    if (is.null(params$col_groups)){
        col_values <- get_col_values(data, data_col_names, params)
        formatted_data <- list(list(col_values = col_values, col_names = data_col_names))
    } else {
        if (!is.factor(params$col_groups)){
            params$col_groups <- factor(params$col_groups)
        }
        formatted_data <- lapply(levels(params$col_groups), function(col_group){
            data_col_names <- data_col_names[which(params$col_groups == col_group)]
            data_col_group <- data[, which(params$col_groups == col_group), drop = FALSE]
            col_values <- get_col_values(data_col_group, data_col_names, params)
            list(col_values = col_values, col_names = data_col_names, col_group_name = col_group)
        })
    }

    list(formatted = formatted_data, unformatted = data)
}

get_heatmap_data <- function(data, params){
    if (is.matrix(data)){
        data <- as.data.frame(data)
    }

    rownames(data) <- params$row_names
    colnames(data) <- params$col_names

    # save colnames before adding extra columns (ex. colorize, order_by)
    data_col_names <- colnames(data)

    # we only create data$colorize when params$colorize is not null
    # if (!is.null(params$colorize)){
    #     data <- reorder_data_by_color(data, params)
    # }

    data <- format_heatmap_data(data, data_col_names, params)

    data
}

validate_heatmap_params <- function(params) {
    if (!is.null(params$main)) {
        params$title <- params$main
    }

    if (!is.null(params$col_names)){
        params$col_names <- as.character(params$col_names)
    } else {
        params$col_names <- as.character(1:ncol(params$data))
    }

    if (!is.null(params$row_names)){
        params$row_names <- as.character(params$row_names)
    } else {
        params$row_names <- as.character(1:nrow(params$data))
    }

    if (!is.null(params$row_groups) & length(params$row_groups) > nrow(params$data)){
        stop(gettextf("data has %d rows, but row_groups contains %d elements: %s", nrow(params$data), length(params$row_groups), paste0(params$row_groups, collapse = ", ")))
    }

    if (!is.null(params$col_groups) & length(params$col_groups) > ncol(params$data)){
        stop(gettextf("data has %d columns, but col_groups contains %d elements: %s", ncol(params$data), length(params$col_groups), paste0(params$col_groups, collapse = ", ")))
    }

    params[names(params) %in% c("data", "main", "...")] <- NULL
    params
}

#' Generates an interactive heatmap
#'
#' @param data matrix, data frame, or vector specifying y-values. A line is defined by the values of one row.
#' @param row_names row names
#' @param col_names column names
#' @param title title of the plot
#' @param main same as title, kept to be compatible with \code{base::plot}
#' @param width,height width and height of the plot
#' @param palette color palette. A vector with a start color, and an end color (optionally, a middle color may be provided between both). The default palette is red, white, and blue. Colors can be a variety of formats:
#' rgb decimal - "rgb(255,255,255)"
#' hsl decimal - "hsl(120,50%,20%)"
#' rgb hexadecimal - "#ffeeaa"
#' rgb shorthand hexadecimal - "#fea"
#' CSS named - "red", "white", "blue" (see http://www.w3.org/TR/SVG/types.html#ColorKeywords)
#' @param color_domain a vector with a start and end value (an optionally a middle value between them). By default it is symmetric c(-max, 0, max)
#' @param padding padding around the top-level object
#' @param ... additional arguments for \code{clickme}
#'
#' @export
clickme_heatmap <- function(data,
                            row_names = rownames(data), col_names = colnames(data),
                            title = NULL, main = NULL,
                            cell_width = 20, cell_height = cell_width,
                            row_groups = NULL, col_groups = NULL,
                            palette = c("#278DD6","#fff","#d62728"), color_domain = NULL,
                            padding = list(top = 80, right = 150, bottom = 30, left = 100),
                            ...){
    params <- as.list(environment())
    params <- validate_heatmap_params(params)
    data <- get_heatmap_data(data, params)

    clickme(data, "heatmap", params = params, ...)
}

# heatmap.3 <- function(x,
#                       Rowv = TRUE, Colv = if (symm) "Rowv" else TRUE,
#                       distfun = dist,
#                       hclustfun = hclust,
#                       dendrogram = c("both","row", "column", "none"),
#                       symm = FALSE,
#                       scale = c("none","row", "column"),
#                       na.rm = TRUE,
#                       revC = identical(Colv,"Rowv"),
#                       add.expr,
#                       breaks,
#                       symbreaks = max(x < 0, na.rm = TRUE) || scale != "none",
#                       col = "heat.colors",
#                       colsep,
#                       rowsep,
#                       sepcolor = "white",
#                       sepwidth = c(0.05, 0.05),
#                       cellnote,
#                       notecex = 1,
#                       notecol = "cyan",
#                       na.color = par("bg"),
#                       trace = c("none", "column","row", "both"),
#                       tracecol = "cyan",
#                       hline = median(breaks),
#                       vline = median(breaks),
#                       linecol = tracecol,
#                       margins = c(5,5),
#                       ColSideColors,
#                       RowSideColors,
#                       side.height.fraction=0.3,
#                       cexRow = 0.2 + 1/log10(nr),
#                       cexCol = 0.2 + 1/log10(nc),
#                       labRow = NULL,
#                       labCol = NULL,
#                       key = TRUE,
#                       keysize = 1.5,
#                       density.info = c("none", "histogram", "density"),
#                       denscol = tracecol,
#                       symkey = max(x < 0, na.rm = TRUE) || symbreaks,
#                       densadj = 0.25,
#                       main = NULL,
#                       xlab = NULL,
#                       ylab = NULL,
#                       lmat = NULL,
#                       lhei = NULL,
#                       lwid = NULL,
#                       NumColSideColors = 1,
#                       NumRowSideColors = 1,
#                       KeyValueName="Value",...){
