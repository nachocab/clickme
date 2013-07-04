Points$methods(

    get_color_legend_counts = function() {
        table(data$color_groups)
    },

    # only for quantitative scales
    get_color_domain_param = function(){
        if (is.null(params$color_domain)){
            params$color_domain <<- range(data$color_groups, na.rm = TRUE)
        }

        params$color_domain
    },

    get_d3_palette = function() {
        palette_names <- names(params$palette)
        categories <- unique(params$color_groups)
        if (is.null(params$palette)){
            if (scale_type(data$color_groups) == "quantitative"){
                params$palette <<- c("steelblue", "#CA0020") # blue-red gradient
            } else {
                params$palette <<- rev(default_colors(length(categories)))
            }
        }

        d3_palette <- toJSON(as.list(params$palette))
        d3_palette
    },

    get_d3_color_scale = function() {
        if (scale_type(data$color_groups) == "quantitative") {
            color_scale <- paste0("d3.scale.linear()
                   .domain(", get_color_domain_param(), ")
                   .range(", get_palette_param(), ")
                   .interpolate(d3.interpolateLab);")
        } else {
            color_scale <- gettextf("d3.scale.ordinal().range(%s);", get_d3_palette())
        }

        color_scale
    },

    get_tooltip_content = function(){
        names <- colnames(data)
        tooltip_contents <- c("\"<strong>\" + d.point_name + \"</strong>\"", paste0("\"", params$ylab, ": \" + format_property(d.y)"), paste0("\"", params$xlab, ": \" + format_property(d.x)"))
        names <- setdiff(names, c("x", "y", "point_name", "color_groups"))

        tooltip_contents <- c(tooltip_contents, sapply(names, function(name) paste0("\"", name, ": \" + format_property(d[\"", name, "\"])")))
        tooltip_contents <- paste(tooltip_contents, collapse = " + \"<br>\" + ")
        tooltip_contents
    },

    # TODO: is this needed?
    get_categorical_domains = function(){
        if (is_character_or_factor(data$x)){
            if (is.character(data$x))
                params$x_categorical_domain <<- unique(data$x)
            else
                params$x_categorical_domain <<- levels(data$x)
        }
        if (is_character_or_factor(data$y)){
            if (is.character(data$y))
                params$y_categorical_domain <<- unique(data$y)
            else
                params$y_categorical_domain <<- levels(data$y)
        }
    }

)




