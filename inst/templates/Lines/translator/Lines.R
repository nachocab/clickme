# params:
# x
# y [NULL]
# names
# x_title
# y_title
# x_lim
# y_lim
# jitter - number
# radius - number
# color_groups - can be a categorical or a continuous variable
# palette
# color_domain
Lines <- setRefClass("Lines",

    contains = "Chart",

    methods = list(

        get_params = function(){
            callSuper()

            # convert params$color_groups to a factor to avoid color ordering issues
            if (!is.null(params$color_groups) && length(unique(params$color_groups)) > 1 && !is.factor(params$color_groups) && scale_type(params$color_groups) == "categorical") {
                if (!is.null(params$color_group_order)){
                    palette_levels <- unique(params$color_group_order)
                } else if (!is.null(names(params$palette))){
                    palette_levels <- names(rev(params$palette))
                } else {
                    palette_levels <- unique(params$color_groups)
                }
                palette_levels <- palette_levels[palette_levels %in% unique(params$color_groups)]
                params$color_groups <<- factor(params$color_groups, levels = palette_levels)
            }

            params$out_width <<- params[["out_width"]] %or% 500
            params$out_height <<- params[["out_height"]] %or% 500
            params$interpolate <<- params[["interpolate"]] %or% "linear"
            params$jitter <<- params[["jitter"]] %or% 0
            params$stroke_width <<- params[["stroke_width"]] %or% 0
            params$x_title <<- params[["x_title"]] %or% "x"
            params$y_title <<- params[["y_title"]] %or% "y"
            params$color_title <<- params[["color_title"]] %or% "Group"

            params$palette <<- validate_palette(params[["palette"]])
            params$color_domain <<- validate_color_domain(params[["color_domain"]])

            internal$extra <<- get_extra()
        },

        get_extra = function() {
            extra <- params$extra %or% list()
            # line-specific options
            extra$line_name <- params[["names"]]
            extra$line_stroke_width <- params[["width"]] %or% 3
            extra$line_stroke_dasharray <- params[["dash"]] %or% "0"
            extra$line_opacity <- params[["opacity"]] %or% 1

            at_least_two_color_groups <- !is.null(params[["color_groups"]]) && length(unique(params[["color_groups"]])) > 1
            if (at_least_two_color_groups)
                extra$color_group <- params[["color_groups"]]

            # point-specific options
            if (is.null(params$radius)){
                # Points should always have a radius to ensure
                # the tooltip is always visible
                extra$radius <- 5
                extra$point_opacity <- 0
            } else {
                extra$radius <- params$radius
                extra$point_opacity <- params$opacity
            }

            # line_stroke_color and point_fill_color don't need to be set
            # because they are computed by get_d3_color_group as
            # color_scale(d.color_group)

            null_if_empty(extra)
        },

        # Ensure that the palette has as at least one color ("#000")
        # If there are color group names, ensure that each has a valid color
        # Ensure that if palette has color group names:
        #   - any color group name assigned with an NA must get replaced with a
        #     default color (useful to determine color group order without
        #     specifying the actual color)
        #   - any color group name without a color must get assigned a default
        #     color
        # set default values, replace invalid values, order with
        # ordered_color_group_names
        validate_palette = function(palette){
            if (!is.null(params$color_groups)){

                ordered_color_group_names <- get_ordered_color_group_names()

                if (is.null(palette)){
                    if (scale_type(params$color_groups) == "quantitative"){
                        palette <- c("#278DD6", "#d62728")
                    } else {
                        palette <- setNames(default_colors(length(ordered_color_group_names)), ordered_color_group_names)
                    }
                } else {
                    if (scale_type(params$color_groups) == "categorical"){
                        palette <- setNames(palette[ordered_color_group_names], ordered_color_group_names)

                        # If any color is NA or NULL, replace it with a default color
                        if (any(is.na(palette) | is.null(palette))) {
                            categories_without_color <- ordered_color_group_names[is.na(palette)]
                            default_palette <- setNames(default_colors(length(categories_without_color)), categories_without_color)
                            palette <- c(na.omit(palette), default_palette)
                        }
                    }
                }
            } else {
                # If no color_groups, use the first palette color or default to black
                palette <- palette[1] %or% "#000"
            }

            # Reverse so the last color group gets the last color
            # palette <- rev(palette)

            palette
        },

        # ordered_color_group_names is used:
        # 1) to know which elements get plotted on top
        # 2) to know the color group names when these are missing from the palette
        get_ordered_color_group_names = function() {
            # The default order is extracted from color_groups
            if (is.factor(params$color_groups)) {
                ordered_color_group_names <- levels(params$color_groups) # factor
            } else {
                if (scale_type(params$color_groups) == "categorical"){
                    ordered_color_group_names <- sort(unique(params$color_groups)) # character
                } else {
                    ordered_color_group_names <- sort(params$color_groups) # numeric
                }
            }

            # If palette has names, they override the default order
            if (!is.null(names(params$palette))) {
                if (scale_type(params$color_groups) != "categorical"){
                    stop("A named palette can only be used with categorical color groups, but they appear to be continuous.\n\nChange palette to an unnamed vector, something like: c(start_color[, middle_color], end_color)", call. = FALSE)
                }

                if (any(duplicated(names(params$palette)))) {
                    duplicated_names <- names(params$palette)[duplicated(names(params$palette))]
                    stop(sprintf("Duplicated names in palette:\n%s\n\n", enumerate(duplicated_names)), call. = FALSE)
                }

                ordered_color_group_names_aux <- names(params$palette)
                missing_color_group_names <- ordered_color_group_names[ordered_color_group_names %notin% names(params$palette)]
                ordered_color_group_names <- c(ordered_color_group_names_aux, missing_color_group_names)
            }

            # If color_group_order is specified, it overrides the default
            # and palette name orders
            if (!is.null(params$color_group_order)) {
                if (scale_type(params$color_groups) != "categorical"){
                    stop("color_group_order can only be used with categorical color groups, but they appear to be continuous.\n\nChange palette to an unnamed vector, something like: c(start_color[, middle_color], end_color)", call. = FALSE)
                }

                if (any(duplicated(params$color_group_order))) {
                    duplicated_names <- params$color_group_order[duplicated(params$color_group_order)]
                    stop(sprintf("Duplicated names in color_group_order:\n%s\n\n", enumerate(duplicated_names)), call. = FALSE)
                }

                ordered_color_group_names_aux <- params$color_group_order
                missing_color_group_names <- ordered_color_group_names[ordered_color_group_names %notin% params$color_group_order]
                ordered_color_group_names <- c(ordered_color_group_names_aux, missing_color_group_names)
            }

            ordered_color_group_names
        },

        # Ensure that the domain used with a D3 color scale is only
        # specified when the scale is quantitative
        validate_color_domain = function(color_domain){
            if (!is.null(color_domain) && scale_type(params$color_groups) == "categorical") {
                stop("color_domain can only be used with numeric scales, but color_groups has categorical values.", call. = FALSE)
            }

            if (is.null(color_domain) && scale_type(params$color_groups) == "quantitative") {
                min <- min(params$color_groups, na.rm = TRUE)
                max <- max(params$color_groups, na.rm = TRUE)

                # If the scale crosses zero, make sure the palette the
                # center of the palette is white (#fff)
                if (min < 0 && max > 0) {
                    color_domain <- c(min, 0, max)
                    params$palette <<- c(params$palette[1], "white", params$palette[2])
                } else {
                    color_domain <- c(min, max)
                }
            }

            color_domain
        }

    )
)

# Generates an interactive scatterplot
#
# x x-values, but only if the "y" param is specified, otherwise it represents
# the y-values. It can be a dataframe,
# a matrix, a vector, a list, or a factor (TODO test this).
#
# y y-values (optional)
# line_names line names
# title title of the plot
# main alias for title
# x_title,y_title x- and y-axis labels
# x_lim,y_lim x- and y-axis limits
# width,height width and height of the plot
# radius the radius of the lines
# box draws a box around the plot
#
# palette color palette. Quantitative scales expect a vector with a start color,
# and an end color (optionally,
# a middle color may be provided between both). Categorical scales expect a vector
 # with a color for each category.
# Use category names to change the default color assignment
# \code{c(category1="color1", category2="color2")}.
# The order in which these colors are specified determines rendering order when
# lines from different categories
# collide (colors specified first appear on top of later ones).
#
# col alias for palette
# color_groups a vector whose values are used to determine the color of the lines.
# If it is a numeric vector, it will assume the scale is quantitative and it will
# generate a gradient using the start and end colors of the palette (also with the
# middle color, if it is provided). If it is a character vector, a logical vector,
# or a factor, it will generate a categorical scale with one color per unique value
# (or level).
#
# color_domain a vector with a start and end value (an optionally a middle value
# between them). It is only used for quantitative scales. Useful when the scale
# is continuous and, for example, we want to ensure it is symmetric in negative
# and positive values.
#
# color_title the title of the color legend
# extra a data frame, list or matrix whose fields will appear in the tooltip
# on hover
# padding padding around the top-level object
# ... additional arguments for \code{clickme}
#
clickme_helper$lines <- function(x, y = NULL, ...){
    params <- list(x = x, y = y, ...)
    lines <- Lines$new(params)

    lines$display()
}
