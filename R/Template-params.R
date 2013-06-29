Template$methods(

    get_params = function() {
        get_unvalidated_params()

        validate_params()
    },

    validate_params = function() {
        validate_padding()
        validate_colorize_and_palette()
        validate_aliases()

        return()
    },

    get_unvalidated_params = function(){

        params$width <<- params$width %||% 980
        params$height <<- params$height %||% 980
        params$padding <<- params$padding %||% list(top = 80, right = 400, bottom = 30, left = 100)
        params$box <<- params$box %||% FALSE

        params$coffee <<- params$coffee %||% FALSE

        params$code <<- params$code %||% paste(deparse(sys.calls()[[1]]), collapse="")

    },

    validate_padding = function(){
        if (length(params$padding) != 4){
            stop("Please provide four padding values. (currently ", paste(params$padding, collapse=", "), ")")
        }

        if (is.null(names(params$padding))) {
            names(params$padding) <<- c("top", "right", "bottom", "left")
        }
    },

    validate_colorize_and_palette = function() {
        if (scale_type(params$colorize) == "categorical" & !is.null(params$color_domain)){
            stop("A color domain can only be specified for quantitative scales. colorize has categorical values.")
        }

        palette_names <- names(params$palette)
        categories <- unique(params$colorize)
        if (!is.null(params$colorize) & !is.null(params$palette) & !is.null(palette_names)) {
            if (scale_type(params$colorize) == "categorical"){
                if (any(palette_names %notin% categories)) {
                    warning("The following palette names don't appear in colorize: ", paste0(palette_names[palette_names %notin% categories], collapse = ", "))
                }

                if (any(is.na(params$palette))) {
                    categories_with_default_colors <- names(params$palette[is.na(params$palette)])
                    default_palette <- setNames(default_colors(length(categories_with_default_colors)), categories_with_default_colors)
                    params$palette <<- c(default_palette, na.omit(params$palette))
                }

                if (any(categories %notin% palette_names)){
                    categories_without_color <- categories[categories %notin% palette_names]
                    missing_palette <- setNames(default_colors(length(categories_without_color)), categories_without_color)
                    params$palette <<- c(missing_palette, params$palette)
                }
            } else {
                stop("The values in colorize imply a quantitative scale, which requires an unnamed vector of the form c(start_color[, middle_color], end_color)")
            }
        }
    },

    reorder_data_by_colorize = function(){
        data$colorize <<- params$colorize

        if (!is.null(names(params$palette))){
            category_order <- unlist(sapply(names(params$palette), function(category) {
                which(data$colorize == category)
            }))
            data <<- data[rev(category_order),]
        } else {
            data <<- data[order(data$colorize, decreasing = TRUE),]
        }
    },

    validate_aliases = function(){
        if (!is.null(params$main)) {
            params$title <<- params$main
            params$main <<- NULL
        }

        # TODO: test that clickme_points(1:10, col=c("blue","red")) isn't interpreted as colorize
        if (!is.null(params[["col"]])) {
            params$palette <<- params[["col"]]
            params[["col"]] <<- NULL
        }
    }

)