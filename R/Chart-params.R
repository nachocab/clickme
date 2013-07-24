Chart$methods(

    # Set the default parameters
    get_params = function(){
        params$port <<- params$port %or% 8000

        params$width <<- params$width %or% 500
        params$height <<- params$height %or% 500
        params$title <<- params$title %or% params$main %or% internal$file$names$template # alias (main)

        params$padding <<- validate_padding(params$padding)

        params$palette <<- params$palette %or% params[["col"]] # alias (col)
        params$rotate_ylab <<- params$rotate_ylab %or% TRUE
        params$show_sidebar <<- params$show_sidebar %or% TRUE

        params$hide_x_tick_labels <<- params$hide_x_tick_labels %or% FALSE # should probably be xaxt = "n"?
    },

    # Ensure there are four padding values named top, right, left and bottom
    validate_padding = function(padding){
        padding <- as.list(padding)
        valid_padding_names <- c("top", "right", "bottom", "left")

        if (any(names(padding) %notin% valid_padding_names)){
            bad_padding_elements <- padding[names(padding) %notin% valid_padding_names]
            stop(gettextf("\n\nWrong padding elements:\n%s", enumerate(bad_padding_elements)))
        } else {
            padding$top <- padding$top       %or% 150
            padding$right <- padding$right   %or% 400
            padding$bottom <- padding$bottom %or% 70
            padding$left <- padding$left     %or% 100
        }

        padding
    }

)