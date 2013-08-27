Heatmap <- setRefClass("Heatmap",

    contains = "Chart",

    methods = list(

        get_params = function(){
            callSuper()

            validate_groups()

            params$row_names <<- params$row_names %or% rownames(params$x) %or% as.character(1:nrow(data$unformatted))
            params$col_names <<- params$col_names %or% colnames(params$x) %or% as.character(1:ncol(data$unformatted))

            params$cell_width <<- params$cell_width %or% 20
            params$cell_height <<- params$cell_height %or% params$cell_width

            params$palette <<- params$palette %or% c("#278DD6","#fff","#d62728")

            params$color_domain <<- validate_color_domain(params$color_domain)
        },

        get_data = function(){
            data <<- list(unformatted = params$x)

            if (is.matrix(data$unformatted)){
                data$unformatted <<- as.data.frame(data$unformatted, stringsAsFactors = FALSE)
            }

            rownames(data$unformatted) <<- params$row_names
            colnames(data$unformatted) <<- params$col_names

            # save colnames before adding extra columns (ex. color_groups, order_by)
            col_names <- colnames(data$unformatted)

            # TODO: we only create data$unformatted$color_groups when params$color_groups is not null
            # if (!is.null(params$color_groups)){
            #     data$unformatted <- reorder_data_by_color_groups(data$unformatted, params)
            # }

            params$width <<- params$width %or% (params$cell_width * ncol(data$unformatted))
            params$height <<- params$height %or% (params$cell_height * nrow(data$unformatted))

            data$formatted <<- format_heatmap_data(data$unformatted, col_names)

            data
        },

        get_col_values = function(data, col_names){
            col_values <- unname(apply(data, 1, function(row){
                row_values <- lapply(1:length(row), function(row_index){
                    list(cell_value = unname(row[row_index]))
                })

                list(row_values = row_values)
            }))

            col_values
        },

        # The heatmap data structure is not as straightforward as the points data structure because
        # it has overlapping definitions: col_group[col_values[row_values[cell_values]], col_group_name, col_names, row_group_names]
        format_heatmap_data = function(data, col_names) {
            if (is.null(params$col_groups)){
                col_values <- get_col_values(data, col_names)
                col_group_list <- list(
                   col_values = col_values,
                   col_names = col_names
                )
                if (!is.null(params$row_groups)){
                    col_group_list$row_group_names <- params$row_groups
                }
                formatted_data <- list(col_group_list)
            } else {
                if (!is.factor(params$col_groups)){
                    params$col_groups <<- factor(params$col_groups)
                }
                formatted_data <- lapply(levels(params$col_groups), function(col_group){
                    col_names <- col_names[which(params$col_groups == col_group)]
                    data_col_group <- data[, which(params$col_groups == col_group), drop = FALSE]
                    col_values <- get_col_values(data_col_group, col_names)
                    col_group_list <- list(
                        col_values = col_values,
                        col_names = col_names,
                        col_group_name = col_group
                    )

                    if (!is.null(params$row_groups)){
                        col_group_list$row_group_names <- params$row_groups
                    }

                    col_group_list
                })
            }

            formatted_data
        },

        # Ensure that the domain used with a D3 color scale is only specified when the scale is quantitative
        validate_color_domain = function(color_domain){
            if (is.null(color_domain)) {
                min <- min(params$x, na.rm = TRUE)
                max <- max(params$x, na.rm = TRUE)

                # If the scale crosses zero, make sure it is centered around zero (white)
                if (min < 0 && max > 0) {
                    color_domain <- c(min, 0, max)
                    if (length(params$palette) != 3){
                        params$palette <<- c(params$palette[1], "white", params$palette[2])
                    }
                } else {
                    color_domain <- c(min, max)
                }
            }

            color_domain
        },

        validate_groups = function(){
            if (!is.null(params$row_groups) & length(params$row_groups) > nrow(params$x)){
                stop(gettextf("\n\n\tdata has %d rows, but row_groups contains %d elements:\n%s",
                     nrow(params$x),
                     length(params$row_groups),
                     enumerate(params$row_groups)))
            }

            if (!is.null(params$col_groups) & length(params$col_groups) > ncol(params$x)){
                stop(gettextf("\n\n\tdata has %d cols, but col_groups contains %d elements:\n%s",
                     ncol(params$x),
                     length(params$col_groups),
                     enumerate(params$col_groups)))
            }
        }

    )
)

clickme_helper$heatmap <- function(x,...){
    params <- list(x = x, ...)
    heatmap <- Heatmap$new(params)

    heatmap$display()
}




