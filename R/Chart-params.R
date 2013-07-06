Chart$methods(

    # Set the default parameters
    get_params = function(){
        params$code <<- params$code %or% TRUE
        get_code()

        params$width <<- params$width %or% 500
        params$height <<- params$height %or% 500
        params$title <<- params$title %or% params$main %or% name

        params$padding <<- validate_padding(params$padding)

        params$palette <<- params$palette %or% params[["col"]]
        params$rotate_label_y <<- params$rotate_label_y %or% TRUE
        params$sidebar <<- params$sidebar %or% TRUE

        params$frameborder <<- params$frameborder %or% 0
        params$box <<- params$box %or% FALSE
        params$coffee <<- params$coffee %or% TRUE
        params$actions <<- validate_actions(params$actions %or% "open")
    },

    # Any parameters to the declared after "hide_right" are removed from the code.
    # Kind of a hack, but useful for sharing code without showing local file names.
    get_code = function(){
        if (params$code){
            code <<- paste(deparse(sys.calls()[[1]]), collapse = "")
            code <<- gsub(",\\s+hide_right.+", "", code)
            code <<- paste0("Code:<br><br>", code, ")")
        } else {
            code <<- ""
        }
    },

    # Ensure there are four padding values named top, right, left and bottom
    validate_padding = function(padding){
        padding <- as.list(padding)
        valid_padding_names <- c("top", "right", "bottom", "left")

        if (any(names(padding) %notin% valid_padding_names)){
            bad_padding_elements <- padding[names(padding) %notin% valid_padding_names]
            stop(gettextf("\n\nWrong padding elements:\n%s", enumerate(bad_padding_elements)))
        } else {
            padding$top <- padding$top       %or% 100
            padding$right <- padding$right   %or% 400
            padding$bottom <- padding$bottom %or% 100
            padding$left <- padding$left     %or% 100
        }

        padding
    },

    # Ensure the actions is any of the valid actions ("open", "link", "iframe") or FALSE (no action)
    validate_actions = function(actions){
        if (FALSE %notin% actions){
            actions <- as.character(actions)
            valid_actions <- c("open", "link", "iframe")
            action_descriptions <- c("open a new browser tab", "return an HTML link", "return an HTML iframe")
            if (any(actions %notin% valid_actions)) {
                bad_action <- actions[actions %notin% valid_actions]
                alternatives <- c(paste(gettextf("\"%s\"",valid_actions), action_descriptions, sep = " => "), "FALSE => Don't do anything")
                stop(gettextf("\n\nInvalid action \"%s\". Please choose one or several among:\n\n%s\n\n", bad_action, enumerate(alternatives)))
            }
        }

        actions
    }

)