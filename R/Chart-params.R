Chart$methods(

    # Set the default parameters
    get_params = function(){
        params$width <<- params$width %or% 980
        params$height <<- params$height %or% 980
        params$padding <<- validate_padding(params$padding %or% list(top = 80, right = 400, bottom = 30, left = 100))
        params$title <<- params$title %or% params$main %or% name

        params$palette <<- params$palette %or% params[["col"]]

        params$frameborder <<- params$frameborder %or% 0
        params$box <<- params$box %or% FALSE
        params$coffee <<- params$coffee %or% TRUE
        params$actions <<- validate_actions(params$actions %or% "open")
        params$code <<- params$code %or% paste(deparse(sys.calls()[[1]]), collapse = "")
    },

    # Ensure there are four padding values named top, right, left and bottom
    validate_padding = function(padding){
        if (length(padding) != 4){
            stop(gettextf("Please provide four padding values. (currently %s)", paste(padding, collapse=", ")))
        }

        if (is.null(names(padding))) {
            names(padding) <- c("top", "right", "bottom", "left")
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