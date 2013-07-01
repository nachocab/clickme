# params:
# x
# y [NULL]
# point_names
# xlab
# ylab
# xlim
# ylim
# jitter
# radius
# x_categorical_domain TODO: remove this
# y_categorical_domain TODO: remove this
Points <- setRefClass("Points",

    contains = "Template",

    methods = list(

        get_params = function(){
            callSuper()

            if (!is.null(params$point_names)){
                # Whatever the user provides as point names, treat it as a character vector
                params$point_names <<- as.character(params$point_names)
            }

            params$title <<- params$title %||% "Points"
            params$xlab <<- params$xlab %||% "x"
            params$ylab <<- params$ylab %||% "y"

        },

        get_data = function(){

            # used for testing
            if (is.null(params$x)) return(NULL)

            data <<- xy_to_data(params$x, params$y)

            if (is.null(params$point_names)){
                data$point_name <<- rownames(data)
            } else {
                data$point_name <<- params$point_names
            }
            rownames(data) <<- NULL

            add_extra_fields()

            # we only create data$colorize when params$colorize is not NULL. When it is NULL, d3_color_scale(null) returns "black"
            if (!is.null(params$colorize)){
                reorder_data_by_colorize()
            }
            # this must be done *after* data has been reordered to ensure the first category (which will be rendered at the bottom) gets the last color
            params$palette <<- rev(params$palette)

            apply_axes_limits()

            get_categorical_domains()
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
        },

        apply_axes_limits = function() {
            if (!is.null(params$xlim)){
                data <<- data[data$x >= params$xlim[1],]
                data <<- data[data$x <= params$xlim[2],]
            }

            if (!is.null(params$ylim)){
                data <<- data[data$y >= params$ylim[1],]
                data <<- data[data$y <= params$ylim[2],]
            }
        },

        add_extra_fields = function() {
            if (!is.null(params$extra)){
                data <<- cbind(data, params$extra)
            }
        },

        # TODO: This is the only method that is called from the translator()
        get_tooltip_content = function(){
            names <- colnames(data)
            tooltip_contents <- c("\"<strong>\" + d.point_name + \"</strong>\"", paste0("\"", params$ylab, ": \" + format_property(d.y)"), paste0("\"", params$xlab, ": \" + format_property(d.x)"))
            names <- setdiff(names, c("x", "y", "point_name", "colorize"))

            tooltip_contents <- c(tooltip_contents, sapply(names, function(name) paste0("\"", name, ": \" + format_property(d[\"", name, "\"])")))
            tooltip_contents <- paste(tooltip_contents, collapse = " + \"<br>\" + ")
            tooltip_contents
        }

    )
)
