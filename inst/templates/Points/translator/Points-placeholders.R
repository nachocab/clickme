Points$methods(

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
                # TODO: this should be levels instead of unique (see Lines)
                # it works now because we order data by color_group_order/palette_name/etc
                # you should do it the same way in lines and points
                color_range <- as.list(unname(params$palette[unique(data$color_group)]))
            }
            color_scale <- sprintf("d3.scale.ordinal().range(%s);", to_json(color_range))
        }

        color_scale
    },

     # internal, template-specific
    get_tooltip_variable_names = function(){
        data_names <- colnames(data)
        # line_name gets special treatment because it is used as title
        # TODO: maybe you could automatically ignore names that start with "_"
        ignore_names <- c("radius", "point_name")
        variable_names <- setdiff(data_names, ignore_names)
        variable_names
    },

    # internal, template-specific
    get_tooltip_variable_value = function(variable_name){
        data[, variable_name]
    },

    # internal
    get_tooltip_formats = function(variable_names){
        sapply(variable_names, function(variable_name) {
            if (is.null(params$tooltip_formats[[variable_name]])) {
                variable_value <- get_tooltip_variable_value(variable_name)
                format <- get_tooltip_format(variable_value)
            } else {
                format <- params$tooltip_formats[[variable_name]]
            }
            format
        })
    },

    # Generate tooltip JS code
    get_tooltip_content = function(){
        variable_names <- get_tooltip_variable_names()
        tooltip_formats <- get_tooltip_formats(variable_names)

        # x and y are always present, but they can have different names (x_title
        # and y_title). color_groups is sometimes present, and it can have a
        # different name (color_title)
        x_title <- ifelse(params$x_title == "", "x", params$x_title)
        y_title <- ifelse(params$y_title == "", "y", params$y_title)
        renamings <- c(x = x_title,
                       y = y_title,
                       color_group = params$color_title)
        names(tooltip_formats)[names(tooltip_formats) %in% names(renamings)] <- renamings[names(renamings) %in% names(tooltip_formats)]
        tooltip_values <- setNames(sapply(variable_names, function(name) sprintf("d['%s']", name)),
                                   names(tooltip_formats))

        tooltip_formatted_values <- sapply(1:length(tooltip_values), function(i){
            if (tooltip_formats[i] == "s"){
                tooltip_values[i]
            } else {
                setNames(sprintf("d3.format('%s')(%s)",
                                 tooltip_formats[i],
                                 tooltip_values[i]),
                         names(tooltip_values[i]))
            }
        })

        title_row <- "<tr><td colspan='2' class='tooltip-title'>\" + d.point_name + \"</td></tr>"
        rows <- c(
                  title_row,
                  sapply(names(tooltip_formatted_values), function(name) {
                      sprintf("<tr class='tooltip-metric'><td class='tooltip-metric-name'>%s</td><td class='tooltip-metric-value'>\" + %s + \"</td></tr>", name, tooltip_formatted_values[name])
                  })
                )
        rows <- paste(rows, collapse = "")
        tooltip_contents <- sprintf("\"<table>%s</table>\"", rows)
        tooltip_contents <- sprintf("function(d) {\nreturn %s\n};", tooltip_contents)
        tooltip_contents
    },

    # When one of the axes is categorical, we need its domain.
    get_categorical_domains = function(){

        # ifelse() can't return NULL
        x_categorical_domain <- if(scale_type(data$x) == "categorical") get_unique_elements(data$x) else NULL
        y_categorical_domain <- if(scale_type(data$y) == "categorical") get_unique_elements(data$y) else NULL
        categorical_domains <- list(x = x_categorical_domain,
                                    y = y_categorical_domain)
        to_json(categorical_domains)
    },

    # I data is numeric, it returns the min/max. Otherwise, it returns unique elements.
    get_data_ranges = function(){
        if (is.numeric(data$x)) {
            x_data_range <- range(data$x, na.rm = TRUE)
            # Ensure that min and max are different
            if (x_data_range[1] == x_data_range[2]){
                x_data_range <- x_data_range + c(-1, 1)
            }
        } else {
            x_data_range <- get_unique_elements(data$x)
        }

        if (is.numeric(data$y)) {
            y_data_range <- range(data$y, na.rm = TRUE)
            # Ensure that min and max are different
            if (y_data_range[1] == y_data_range[2]){
                y_data_range <- y_data_range + c(-1, 1)
            }
        } else {
            y_data_range <- get_unique_elements(data$y)
        }

        data_ranges <- list(x = x_data_range,
                            y = y_data_range)
        to_json(data_ranges)
    }
)

