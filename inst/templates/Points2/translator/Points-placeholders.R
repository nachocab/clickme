Points$methods(

    get_color_legend_counts = function() {
        table(params$color_groups)
    },

    # A D3 color scale may be quantitative or categorical, depending on params$color_groups
    # Both types of scales have a range (the colors they use)
    # Quantitative scales also have a domain (the min and max values used to interpolate them into colors)
    get_d3_color_scale = function() {
        # we use as.list so c("#000") gets converted to ["#000"] and not "#000"
        color_range <- as.list(unname(params$palette))
        if (scale_type(params$color_groups) == "quantitative") {
            color_scale <- gettextf("d3.scale.linear()
                   .domain(%s)
                   .range(%s)
                   .interpolate(d3.interpolateLab);",
                   to_json(params$color_domain),
                   to_json(color_range))
        } else {
            color_scale <- gettextf("d3.scale.ordinal().range(%s);", to_json(color_range))
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

    # When one of the axes is categorical, we need its domain
    get_categorical_domains = function(){

        # ifelse() can't return NULL
        x_categorical_domain <- if(scale_type(data$x) == "categorical") get_unique_elements(data$x) else NULL
        y_categorical_domain <- if(scale_type(data$y) == "categorical") get_unique_elements(data$y) else NULL

        categorical_domains <- gettextf("{
          x: %s,
          y: %s
        }", to_json(x_categorical_domain), to_json(y_categorical_domain))

        categorical_domains
    },

    # returns the min/max if numeric and unique elements otherwise
    get_data_ranges = function(){
        x_data_range <- if (is.numeric(data$x)) range(data$x, na.rm = TRUE) else get_unique_elements(data$x)
        y_data_range <- if (is.numeric(data$y)) range(data$y, na.rm = TRUE) else get_unique_elements(data$y)

        data_ranges <- gettextf("{
          x: %s,
          y: %s
        }", to_json(x_data_range), to_json(y_data_range))

        data_ranges
    }

)




