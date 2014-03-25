Points$methods(

    get_data = function(){
        data <<- unify_format(params[["x"]], params[["y"]])
        add_names()
        add_extra_fields()
        cluster_data_by_color_group(params$color_groups, group_variable = "color_group", group_order = internal$ordered_color_group_names)

        # Reverse so the last color group gets the last color
        params$palette <<- rev(params$palette)

        apply_axes_limits()
        remove_invalid()
        params$tooltip_formats <<- validate_tooltip_formats(params$tooltip_formats)
    },


    # internal, template-specific
    unify_format = function(x, y){
        data <- xy_to_data(x, y)
        data
    },

    # internal
    add_names = function(){
        data$point_name <<- as.character(params$names %or% rownames(data))
        rownames(data) <<- NULL
        return()
    },

    # internal
    # Add any extra fields to the data object.
    # extra can be a list with as many elements as rows in data, or a data.frame or matrix with as many rows as data
    # This methods should be called before grouping rows
    add_extra_fields = function() {
        data$radius <<- params$radius
        if (!is.null(params$extra)){
            data <<- cbind(data, params$extra)
        }
        return()
    },

    # internal
    # It makes adjacent rows that belong to the same group
    # groups must have as many elements as data has rows
    # group_variable is the name of the varible that will be used to group the rows
    # group_order must have as many elements as groups, by default the order is
    # alphanumeric
    cluster_data_by_color_group = function(groups, group_variable, group_order = NULL){
       if (!is.data.frame(data)){
           stop("\nData must be a dataframe to group its rows")
       }

       if (length(groups) > 1){
           data[[group_variable]] <<- as.character(groups)

           if (!is.null(group_order)){
               order <- unlist(sapply(group_order, function(group_name) {
                   which(data[[group_variable]] == group_name)
               }))
           } else {
               order <- order(data[[group_variable]])
           }

           # Reverse so the first element is plotted last (and therefore
           # appears on top)
           data <<- data[rev(order),]
       }
       return()
    },

    # internal
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
    },

    # internal
    validate_tooltip_formats = function(tooltip_formats){
        if (any(names(tooltip_formats) %notin% colnames(data))){
            wrong_names <- names(tooltip_formats)[names(tooltip_formats) %notin% colnames(data)]
            stop(sprintf("\nThe following format names are not x, y, or any of the extra names:\n%s\n\n", enumerate(wrong_names)))
        }

        tooltip_formats
    }

)