Heatmap$methods(

    get_d3_color_scale = function(){
       color_range <- as.list(unname(params$palette))
       color_scale <- gettextf("d3.scale.linear()
              .domain(%s)
              .range(%s)
              .interpolate(d3.interpolateLab)",
              to_json(params$color_domain),
              to_json(color_range))

       color_scale
    },

    get_tooltip_content = function(){

        tooltip_names <- colnames(data$unformatted)
        tooltip_formats <- get_formats(data$unformatted[, tooltip_names], params$formats)
        tooltip_values <- setNames(sapply(tooltip_names, function(name) gettextf("d['%s']", name)), names(tooltip_formats))

        tooltip_formatted_values <- sapply(1:length(tooltip_values), function(i){
            if (tooltip_formats[i] == "s"){
                tooltip_values[i]
            } else {
                setNames(gettextf("d3.format('%s')(%s)", tooltip_formats[i], tooltip_values[i]), names(tooltip_values[i]))
            }
        })

        rows <- sapply(names(tooltip_formatted_values), function(name) {
            gettextf("<tr class='tooltip-metric'><td class='tooltip-metric-name'>%s</td><td class='tooltip-metric-value'>\" + %s + \"</td></tr>", name, tooltip_formatted_values[name])
        })
        rows <- paste(rows, collapse = "")

        tooltip_contents <- gettextf("\"<table>%s</table>\"", rows)

        tooltip_contents
    }

)