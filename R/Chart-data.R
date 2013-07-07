Chart$methods(

    get_data = function(){
        data <<- params$data
    },

    # Add any extra fields to the data object.
    # extra can be a list with as many elements as rows in data, or a data.frame or matrix with as many rows as data
    # This methods should be called before grouping rows
    add_extra_data_fields = function() {
        if (!is.null(params$extra)){
            data <<- cbind(data, params$extra)
        }
    },

    # data must be a data.frame
    # groups must have as many elements as data has rows
    # group_order must have as many elements as groups, by default the order is alphanumeric
    group_data_rows = function(groups, group_order = NULL){
        if (!is.data.frame(data)){
            stop("\n\n\tdata must be a dataframe to group its rows")
        }

        if (length(groups) > 1){
            data$group <<- as.character(groups)

            if (!is.null(group_order)){
                order <- unlist(sapply(group_order, function(group_name) {
                    which(data$group == group_name)
                }))
            } else {
                order <- order(data$group)
            }

            # We reverse it so the first element is plotted last (and therefore appears on top)
            data <<- data[rev(order),]
        }
    }

)