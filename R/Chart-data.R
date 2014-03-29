Chart$methods(

    # We keep this so dummy examples work, but this method is usually overloaded
    # by the template that inherits it
    get_data = function(){
        data <<- params$x
    },

    validate_tooltip_formats = function(data_names){
        if (any(names(params$tooltip_formats) %notin% data_names)){
            wrong_names <- names(params$tooltip_formats)[names(params$tooltip_formats) %notin% data_names]
            stop(sprintf("\nThe following format names are not x, y, or any of the extra names:\n%s\n\n",
                 enumerate(wrong_names)))
        }
        return()
    }

)