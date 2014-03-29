Points$methods(
    get_data = function(){
        extra <- list(radius = params$radius)
        if (!is.null(params$extra)){
            if (is.matrix(params$extra)){
                extra <- c(extra, as.data.frame(params$extra))
            } else {
                extra <- c(extra, params$extra)
            }
        }

        data <<- unify_format(x = params[["x"]],
                              y = params[["y"]],
                              names = params$names,
                              extra = extra)

        if (!is.null(params$color_groups) && length(params$color_groups) > 1){
            point_names <- rownames(data)
            ordered_color_group_names <- get_ordered_color_group_names()
            data[["color_group"]] <<- as.character(params$color_groups)

            data <<- order_data_by_color_group(data,
                                               point_names,
                                               params$color_groups,
                                               ordered_color_group_names)
        }
        apply_axes_limits()
        remove_invalid()

        # Reverse so the last color group gets the last color
        # TODO: why isn't this in validate_palette?
        params$palette <<- rev(params$palette)

        # we call validate_tooltip_formats here because it depends on data
        data_names <- colnames(data)
        validate_tooltip_formats(data_names)
    },


    # internal, template-specific
    unify_format = function(x, y, names, extra){
        data <- xy_to_data(x, y)

        data$point_name <- as.character(names %or% rownames(data))
        rownames(data) <- NULL

        if (!is.null(extra)){
            data <- cbind(data, extra)
        }
        data
    },

    # internal, template-specific
    # It makes adjacent rows that belong to the same group
    # groups must have as many elements as data has rows
    # group_variable is the name of the varible that will be used to group the rows
    # group_order must have as many elements as groups, by default the order is
    # alphanumeric
    order_data_by_color_group = function(data, data_names, color_groups, ordered_color_group_names){
        names_groups <- data.frame(names = data_names, groups = color_groups)
        data_order <- unlist(sapply(ordered_color_group_names, function(group_name) {
            which(names_groups$group == group_name)
        }))

        # Reverse so the first element is plotted last (and therefore
        # appears on top)
        data_order <- rev(data_order)
        data <- data[data_order,]
        data
    },

    # internal
    # TODO: maybe this should change the viewport but plot all the points
    apply_axes_limits = function() {
        if (!is.null(params$xlim)){
            data <<- data[data$x >= params$xlim[1],]
            data <<- data[data$x <= params$xlim[2],]
        }

        if (!is.null(params$ylim)){
            data <<- data[data$y >= params$ylim[1],]
            data <<- data[data$y <= params$ylim[2],]
        }
        return()
    },

    # internal
    remove_invalid = function(){
        data <<- na.omit(data)
        return()
    }

)