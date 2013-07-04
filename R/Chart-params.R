Chart$methods(

    # Set the default parameters
    get_params = function(){
        params$width <<- params$width %or% 980
        params$height <<- params$height %or% 980
        params$padding <<- validate_padding(params$padding %or% list(top = 80, right = 400, bottom = 30, left = 100))
        params$title <<- params$title %or% params$main %or% name

        params$palette <<- validate_palette(params$palette %or% params[["col"]])
        params$color_groups <<- params$color_groups %or% "#000"
        params$color_domain <<- validate_color_domain(params$color_domain %or% NULL)

        params$frameborder <<- params$frameborder %or% 0
        params$box <<- params$box %or% FALSE
        params$coffee <<- params$coffee %or% TRUE
        params$action <<- validate_action(params$action %or% "open")
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

    # Ensure that if color group names are present in the palette, the scale is categorical.
    # Ensure that all the color group names present in the palette correspond to a color group
    # Ensure that any color group name assigned to an NA gets a default color (useful to determine color group order without specifying a color)
    # Ensure that any color group name without a color gets a default color
    validate_palette = function(palette) {
        palette_names <- names(palette)
        color_group_names <- unique(params$color_groups)

        if (!is.null(palette_names)) {
            if (scale_type(params$color_groups) == "categorical"){
                if (any(palette_names %notin% color_group_names)) {
                    warning(gettextf("\n\nThe palette contains color group names that don't appear in color_groups:\n\n%s", paste0(palette_names[palette_names %notin% color_group_names], collapse = ", ")))
                }

                # If any color is NA, replace it with a default color
                if (any(is.na(palette))) {
                    color_group_names_with_default_colors <- names(palette[is.na(palette)])
                    default_palette <- setNames(default_colors(length(color_group_names_with_default_colors)), color_group_names_with_default_colors)
                    palette <- c(default_palette, na.omit(palette))
                }

                # If any color_group doesn't have a matching color, use a default color
                if (any(color_group_names %notin% palette_names)){
                    color_group_names_without_color <- color_group_names[color_group_names %notin% palette_names]
                    missing_palette <- setNames(default_colors(length(color_group_names_without_color)), color_group_names_without_color)
                    palette <- c(missing_palette, params$palette)
                }
            } else {
                stop("\n\n\tA palette with color group names can't be used with numeric values.\n\nChange color_groups to an unnamed vector like: c(start_color[, middle_color], end_color)")
            }
        }

        palette
    },

    # Ensure that the domain used with a D3 color scale is only specified when the scale is quantitative
    validate_color_domain = function(color_domain){
        if (scale_type(params$color_groups) == "categorical" & !is.null(color_domain)){
            stop("\n\ncolor_domain can only be used with numeric scales, but color_groups has categorical values.")
        }

        color_domain
    },

    # Ensure the action is FALSE (no action) or any of the valid actions ("open", "link", "iframe")
    validate_action = function(action){
        if (action != FALSE){
            action <- as.character(action)
            valid_actions <- c("open", "link", "iframe")
            action_descriptions <- c("open a new browser tab", "return an HTML link", "return an HTML iframe")
            if (any(action %notin% valid_actions)) {
                bad_action <- action[action %notin% valid_actions]
                alternatives <- c(paste(gettextf("\"%s\"",valid_actions), action_descriptions, sep = " => "), "FALSE => Don't do anything")
                stop(gettextf("\n\nInvalid action \"%s\". Please choose one or several among:\n\n%s\n\n", bad_action, enumerate(alternatives)))
            }
        }

        action
    }

)