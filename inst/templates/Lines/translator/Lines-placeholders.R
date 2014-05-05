Lines$methods(

    get_color_legend_counts = function() {
        table(params$color_groups)
    },

    # A D3 color scale may be quantitative or categorical, depending on
    # params$color_groups. Both types of scales have a range (the colors they use)
    # Quantitative scales also have a domain (the min and max values used
    # to interpolate them into colors)
    get_d3_color_scale = function() {
        # we use as.list() so c("#000") gets converted to ["#000"] and not "#000"
        if (scale_type(params$color_groups) == "quantitative") {
            color_range <- as.list(unname(params$palette))
            color_scale <- sprintf("d3.scale.linear()
                   .domain(%s)
                   .range(%s)
                   .interpolate(d3.interpolateLab);",
                   to_json(params$color_domain),
                   to_json(color_range))
        } else {
            if (is.null(params$color_groups)){
                color_range <- as.list(unname(params$palette))
            } else {
                color_range <- as.list(unname(params$palette[levels(params$color_groups)]))
            }
            color_scale <- sprintf("d3.scale.ordinal()
                                        .domain(%s)
                                        .range(%s);",
                                        to_json(names(params$palette)),
                                        to_json(color_range))
        }

        color_scale
    },

    get_d3_color_group = function(){
        if (is.null(params$color_groups)){
            stroke_color <- to_json(params$palette)
        } else {
            stroke_color <- "color_scale(d.color_group)"
        }

        stroke_color <- sprintf("function(d) {\nreturn %s\n};",
                                stroke_color)
        stroke_color
    },

    # internal, template-specific
    get_tooltip_variable_names = function(){
        data_names <- names(data[[1]][[1]])
        # line_name gets special treatment because it is used as title
        ignore_names <- c("line_name",
                          "line_stroke_width",
                          "line_stroke_dasharray",
                          "line_opacity",
                          "point_opacity",
                          "radius"
                          )
        variable_names <- setdiff(data_names, ignore_names)
        variable_names
    },

    # internal, template-specific
    get_tooltip_variable_value = function(variable_name){
        unlist(lapply(data, function(x) lapply(x, function(y) y[[variable_name]])))
    },

    # internal
    get_tooltip_formats = function(variable_names){
        tooltip_formats <- sapply(variable_names, function(variable_name) {
            if (is.null(params$tooltip_formats[[variable_name]])) {
                variable_value <- get_tooltip_variable_value(variable_name)
                format <- get_tooltip_format(variable_value)
            } else {
                format <- params$tooltip_formats[[variable_name]]
            }
            format
        })

        # x and y are always present, but they can have different names (x_title
        # and y_title). color_groups is sometimes present, and it can have a
        # different name (color_title)
        renamings <- c(x = params$x_title,
                       y = params$y_title,
                       color_group = params$color_title)
        names(tooltip_formats)[names(tooltip_formats) %in% names(renamings)] <- renamings[names(renamings) %in% names(tooltip_formats)]

        tooltip_formats
    },

    # Generate tooltip JS code
    get_tooltip_content = function(){
        variable_names <- get_tooltip_variable_names()
        tooltip_formats <- get_tooltip_formats(variable_names)

        d3_tooltip_values <- setNames(sapply(variable_names, function(name) sprintf("d['%s']", name)),
                                      names(tooltip_formats))

        tooltip_formatted_values <- sapply(1:length(d3_tooltip_values), function(i){
            if (tooltip_formats[i] == "s"){
                d3_tooltip_values[i]
            } else {
                setNames(sprintf("d3.format('%s')(%s)",
                                 tooltip_formats[i],
                                 d3_tooltip_values[i]),
                         names(d3_tooltip_values[i]))
            }
        })

        title_row <- "<tr><td colspan='2' class='tooltip-title'>\" + d.line_name + \"</td></tr>"
        rows <- c(title_row,
                  sapply(names(tooltip_formatted_values), function(name) {
                      sprintf("<tr class='tooltip-metric'><td class='tooltip-metric-name'>%s</td><td class='tooltip-metric-value'>\" + %s + \"</td></tr>",
                              name,
                              tooltip_formatted_values[name])
                  })
        )
        rows <- paste(rows, collapse = "")
        tooltip_contents <- sprintf("\"<table>%s</table>\"", rows)
        tooltip_contents <- sprintf("function(d) {\nreturn %s\n};", tooltip_contents)
        tooltip_contents
    },

    # When one of the axes is categorical, we need its domain.
    # categorical_domains must exist, even if it's {x:null,y:null}
    get_categorical_domains = function(){
        x_categorical_domain <- y_categorical_domain <- NULL
        data_x <- get_point_value(data, "x")
        data_y <- get_point_value(data, "y")

        if(scale_type(data_x) == "categorical")
            x_categorical_domain <- get_unique_elements(data_x)

        if(scale_type(data_y) == "categorical")
            y_categorical_domain <- get_unique_elements(data_y)

        categorical_domains <- sprintf("{
          x: %s,
          y: %s
        }", to_json(x_categorical_domain), to_json(y_categorical_domain))

        categorical_domains
    },

    # If data is numeric, it returns the min/max.
    # Otherwise, it returns unique elements.
    get_data_ranges = function(){
        data_x <- get_point_value(data, "x")
        data_y <- get_point_value(data, "y")

        if (is.numeric(data_x)) {
            x_data_range <- range(data_x, na.rm = TRUE)
            # Ensure that min and max are different
            if (x_data_range[1] == x_data_range[2]){
                x_data_range <- x_data_range + c(-1, 1)
            }
        } else {
            x_data_range <- get_unique_elements(data_x)
        }

        if (is.numeric(data_y)) {
            y_data_range <- range(data_y, na.rm = TRUE)
            # Ensure that min and max are different
            if (y_data_range[1] == y_data_range[2]){
                y_data_range <- y_data_range + c(-1, 1)
            }
        } else {
            y_data_range <- get_unique_elements(data_y)
        }

        data_ranges <- sprintf("{
          x: %s,
          y: %s
        }", to_json(x_data_range), to_json(y_data_range))

        data_ranges
    }

)

