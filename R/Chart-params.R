Chart$methods(

    # Set the default parameters
    get_params = function(){
        params$code <<- params$code %or% FALSE
        code <<- get_code()

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
        params$action <<- validate_actions(params$action)
    },

    # Any parameters to the declared after "hide" are removed from the code.
    # Kind of a hack, but useful for sharing code without showing local file names.
    get_code = function(){
        if (params$code){
            calls <- as.character(sys.calls())
            call <- calls[str_detect(calls, "^clickme\\(")]
            call <- gsub(",\\s+hide.+", "", call)
            call <- paste0("Code:<br><br>", call, ")")
        } else {
            call <- ""
        }
        call
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
            padding$bottom <- padding$bottom %or% 70
            padding$left <- padding$left     %or% 100
        }

        padding
    },

    # Ensure the action is any of the valid actions ("open", "link", "iframe") or FALSE (no action)
    validate_actions = function(action){
        if (is.null(action)){
            action <- if (interactive()) "open" else "iframe"
        } else {
            if (FALSE %notin% action){
                action <- as.character(action)
                valid_actions <- c("open", "link", "iframe")
                action_descriptions <- c("open a new browser tab", "return an HTML link", "return an HTML iframe")
                if (any(action %notin% valid_actions)) {
                    bad_action <- action[action %notin% valid_actions]
                    alternatives <- c(paste(gettextf("\"%s\"",valid_actions), action_descriptions, sep = " => "), "FALSE => Don't do anything")
                    stop(gettextf("\n\nInvalid action \"%s\". Please choose one or several among:\n\n%s\n\n", bad_action, enumerate(alternatives)))
                }
            }
        }

        action
    }

)