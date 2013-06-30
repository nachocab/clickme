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
#' @export
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

#' Generates an interactive scatterplot
#'
#' @param x x-values, but only if the "y" param is specified, otherwise it represents the y-values. It can be a dataframe, a matrix, a vector, a list, or a factor (TODO test this).
#' @param y y-values (optional)
#' @param point_names point names
#' @param title title of the plot
#' @param main alias for title
#' @param xlab,ylab x- and y-axis labels
#' @param xlim,ylim x- and y-axis limits
#' @param width,height width and height of the plot
#' @param radius the radius of the points
#' @param box draws a box around the plot
#' @param palette color palette. Quantitative scales expect a vector with a start color, and an end color (optionally, a middle color may be provided between both). Categorical scales expect a vector with a color for each category. Use category names to change the default color assignment \code{c(category1="color1", category2="color2")}. The order in which these colors are specified determines rendering order when points from different categories collide (colors specified first appear on top of later ones). Colors can be a variety of formats: "#ffeeaa" "rgb(255,255,255)" "hsl(120,50%,20%)" "blue" (see http://www.w3.org/TR/SVG/types.html#ColorKeywords)
#' @param col alias for palette
#' @param colorize a vector whose values are used to determine the color of the points. If it is a numeric vector, it will assume the scale is quantitative and it will generate a gradient using the start and end colors of the palette (also with the middle color, if it is provided). If it is a character vector, a logical vector, or a factor, it will generate a categorical scale with one color per unique value (or level).
#' @param color_domain a vector with a start and end value (an optionally a middle value between them). It is only used for quantitative scales. Useful when the scale is continuous and, for example, we want to ensure it is symmetric in negative and positive values.
#' @param color_title the title of the color legend
#' @param extra a data frame, list or matrix whose fields will appear in the tooltip on hover
#' @param padding padding around the top-level object
#' @param ... additional arguments for \code{clickme}
#'
#' @export

Clickme$methods(

    points = function(x, y = NULL,
                      point_names = NULL,
                      xlim = NULL, ylim = NULL,
                      radius = 5,
                      jitter = 0,
                      ...){
        params <- as.list(environment())
        points <- Points$new(params)

        points$display()
    }

)
