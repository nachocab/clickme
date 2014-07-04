Points$methods(
    get_data = function(){
        tmp_data <- unify_format()
        rownames(tmp_data) <- NULL

        if (!is.null(internal$extra$color_group))
            tmp_data <- order_by_color_group(tmp_data)

        tmp_data <- apply_axes_limits(tmp_data)
        tmp_data <- remove_invalid(tmp_data)

        # we call validate_tooltip_formats here because it depends on data
        data_names <- colnames(tmp_data)
        validate_tooltip_formats(data_names)

        data <<- tmp_data
    },

    # internal, template-specific
    unify_format = function(){
        data <- xy_to_data(params[["x"]], params[["y"]])
        num_points <- nrow(data)
        extra <- validate_extra(internal$extra, num_points)
        data <- add_extra(data, extra)
        data
    },

    add_extra = function(data, extra){
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
    order_by_color_group = function(data){
        ordered_color_group_names <- get_ordered_color_group_names()
        data_names <- rownames(data)
        names_groups <- data.frame(names = data_names, groups = internal$extra$color_group)
        data_order <- unlist(sapply(ordered_color_group_names, function(group_name) {
            which(names_groups$groups == group_name)
        }))

        # Reverse so the first element is plotted last (and therefore
        # appears on top)
        data_order <- rev(data_order)
        data <- data[data_order,]
        data
    },

    # internal
    # TODO: maybe this should change the viewport but plot all the points
    apply_axes_limits = function(data) {
        if (!is.null(params$x_lim)){
            if (length(params$x_lim) != 2)
                stop("x_lim should specify a min and a max value\n", call. = FALSE)
            data <- data[data$x >= params$x_lim[1],]
            data <- data[data$x <= params$x_lim[2],]
        }

        if (!is.null(params$y_lim)){
            if (length(params$y_lim) != 2)
                stop("y_lim should specify a min and a max value\n", call. = FALSE)
            data <- data[data$y >= params$y_lim[1],]
            data <- data[data$y <= params$y_lim[2],]
        }
        data
    },

    # internal
    remove_invalid = function(data){
        data <- na.omit(data)
        data
    },

    # internal
    validate_extra = function(extra, num_points){
        param_lengths <- sapply(extra, length)
        if (any(param_lengths > num_points))
            stop(sprintf("Number of points is %s, but the following parameters have more values than points: \n%s",
                    num_points,
                    enumerate(names(extra)[param_lengths > num_points])), call. = FALSE)

        extra$point_name <- extra$point_name %or% as.character(1:num_points)
        extra
    }

)