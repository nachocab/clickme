# params:
# x
# y [NULL]
# names
# xlab
# ylab
# xlim
# ylim
# jitter
# radius
# x_categorical_domain TODO: remove this
# y_categorical_domain TODO: remove this
Points <- setRefClass("Points",

    contains = "Chart",

    methods = list(

        get_params = function(){
            callSuper()

            params$title <<- params$title %or% "Points"
            params$xlab <<- params$xlab %or% "x"
            params$ylab <<- params$ylab %or% "y"

        },

        get_data = function(){
            if (is.null(params$x)) {
                # used for testing
                return(NULL)
            }

            data <<- xy_to_data(params$x, params$y)
            data$point_name <<- as.character(params$names %or% rownames(data))
            rownames(data) <<- NULL

            add_extra_data_fields()
            group_data_rows()

            apply_axes_limits()

            get_categorical_domains()
        },

        group_data_rows = function(){
            callSuper(params$color_groups, rev(names(params$palette)))

            # We reverse it so the last color group gets the last color
            params$palette <<- rev(params$palette)
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

        get_tooltip_content = function(){
            names <- colnames(data)
            tooltip_contents <- c("\"<strong>\" + d.point_name + \"</strong>\"", paste0("\"", params$ylab, ": \" + format_property(d.y)"), paste0("\"", params$xlab, ": \" + format_property(d.x)"))
            names <- setdiff(names, c("x", "y", "point_name", "color_groups"))

            tooltip_contents <- c(tooltip_contents, sapply(names, function(name) paste0("\"", name, ": \" + format_property(d[\"", name, "\"])")))
            tooltip_contents <- paste(tooltip_contents, collapse = " + \"<br>\" + ")
            tooltip_contents
        }

    )
)
