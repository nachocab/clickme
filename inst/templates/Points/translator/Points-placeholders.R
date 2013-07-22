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

    # Generate tooltip JS code
    get_tooltip_content = function(){

        # Point names get special treatment because they are used as titles
        tooltip_names <- setdiff(colnames(data), c("point_name"))

        tooltip_formats <- get_formats(data[, tooltip_names], params$formats)

        # x and y are always present, but they can have different names (xlab and ylab)
        # color_groups is sometimes present, and it can have a different name (color_title)
        renamings <- c(x = params$xlab, y = params$ylab, color_group = params$color_title)
        names(tooltip_formats)[names(tooltip_formats) %in% names(renamings)] <- renamings[names(renamings) %in% names(tooltip_formats)]
        tooltip_values <- setNames(sapply(tooltip_names, function(name) gettextf("d['%s']", name)), names(tooltip_formats))

        tooltip_formatted_values <- sapply(1:length(tooltip_values), function(i){
            if (tooltip_formats[i] == "s"){
                tooltip_values[i]
            } else {
                setNames(gettextf("d3.format('%s')(%s)", tooltip_formats[i], tooltip_values[i]), names(tooltip_values[i]))
            }
        })

        title_row <- "<tr><td colspan='2' class='tooltip-title'>\" + d.point_name + \"</td></tr>"
        rows <- c(title_row, sapply(names(tooltip_formatted_values), function(name) {
            gettextf("<tr class='tooltip-metric'><td class='tooltip-metric-name'>%s</td><td class='tooltip-metric-value'>\" + %s + \"</td></tr>", name, tooltip_formatted_values[name])
        }))
        rows <- paste(rows, collapse = "")

        tooltip_contents <- gettextf("\"<table>%s</table>\"", rows)

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




