# params:
# x
# y [NULL]
# names
# xlab
# ylab
# xlim
# ylim
# jitter - number
# radius - number
# color_groups - can be a categorical or a continuous variable
# palette
# color_domain
Points <- setRefClass("Points",

    contains = "Chart",

    methods = list(

        get_params = function(){
            callSuper()

            params$radius <<- params$radius %or% 5
            params$jitter <<- params$jitter %or% 0

            params$xlab <<- params$xlab %or% "x"
            params$ylab <<- params$ylab %or% "y"

            get_color_params()
        },

        # Responsible for getting color_group_order, palette and color_domain
        get_color_params = function(){
            if (!is.null(params$color_groups)){

                # we could make params$color_group_order a public param, but it can be done just as well with params$palette.
                params$color_group_order <<- get_color_group_order()
                params$palette <<- validate_palette(params$palette)
            } else {
                if (!is.null(params$palette)){
                    message("\n\tNo color_groups provided. Ignoring palette.\n")
                }
                params$palette <<- "#000"
            }

            params$color_domain <<- validate_color_domain(params$color_domain)

        },

        # If palette doesn't have names and color_groups is a factor, use its levels to define the order of the color groups
        # If palette doesn't have names and color_groups is not a factor, use the unique character values to define the order of the color groups
        # If palette has names, ensure the scale is categorical, and use the names to define the order of the color groups
        get_color_group_order = function() {
            if (is.null(names(params$palette))) {
                if (is.factor(params$color_groups)) {
                    color_group_order <- levels(params$color_groups)
                } else {
                    if (scale_type(params$color_groups) == "quantitative"){
                        color_group_order <- sort(params$color_groups)
                    } else {
                        color_group_order <- sort(as.character(unique(params$color_groups)))
                    }
                }
            } else {
                if (scale_type(params$color_groups) != "categorical"){
                    stop("\n\n\tA named palette can only be used with categorical color groups, but these appear to be continuous.\n\nChange palette to an unnamed vector, something like: c(start_color[, middle_color], end_color)")
                }

                color_group_order <- validate_palette_names(names(params$palette))
            }

            color_group_order
        },

        # If the palette is missing names used in color_groups, append them
        # If the palette has extra names not used in color_groups, give a warning and remove them
        validate_palette_names = function(palette_names) {
            color_group_unique_elements <- as.character(unique(params$color_groups))
            if (any(color_group_unique_elements %notin% palette_names)){
                color_groups_without_color <- color_group_unique_elements[color_group_unique_elements %notin% palette_names]
                palette_names <- c(palette_names, color_groups_without_color)
            }
            if (any(palette_names %notin% color_group_unique_elements)) {
                message(gettextf("\n\tThe palette contains color group names that don't appear in color_groups:\n\n\t%s", paste(palette_names[palette_names %notin% color_group_unique_elements], collapse = ", ")), "\n")
                palette_names <- palette_names[palette_names %in% color_group_unique_elements]
            }

            palette_names
        },

        validate_palette = function(palette) {
            if (is.null(palette)){
                if (scale_type(params$color_groups) == "quantitative"){
                    palette <- c("#278DD6", "#d62728")
                } else {
                    palette <- setNames(default_colors(length(params$color_group_order)), params$color_group_order)
                }
            } else {
                if (scale_type(params$color_groups) == "categorical"){
                    if (!is.null(names(palette))){
                        palette <- palette[params$color_group_order]
                    }
                    names(palette) <- params$color_group_order

                    # If any color is NA or NULL, replace it with a default color
                    if (any(is.na(palette) || is.null(palette))) {
                        color_group_order_with_default_colors <- params$color_group_order[is.na(palette)]
                        default_palette <- setNames(default_colors(length(color_group_order_with_default_colors)), color_group_order_with_default_colors)
                        palette <- c(default_palette, na.omit(palette))
                    }
                }
            }

            palette
        },

        # Ensure that the palette has as at least one color ("#000")
        # If there are color group names, ensure that each has a valid color
        # Ensure that if palette has color group names:
        #   any color group name assigned with an NA must get replaced with a default color (useful to determine color group order without specifying the actual color)
        #   any color group name without a color must get assigned a default color


        # Ensure that the domain used with a D3 color scale is only specified when the scale is quantitative
        validate_color_domain = function(color_domain){
            if (!is.null(color_domain) && scale_type(params$color_groups) == "categorical") {
                stop("\n\ncolor_domain can only be used with numeric scales, but color_groups has categorical values.")
            }

            if (is.null(color_domain) && scale_type(params$color_groups) == "quantitative") {
                min <- min(params$color_groups, na.rm = TRUE)
                max <- max(params$color_groups, na.rm = TRUE)
                if (min < 0 && max > 0) {
                    color_domain <- c(min, 0, max)
                    params$palette <<- c(params$palette[1], "#fff", params$palette[2])
                } else {
                    color_domain <- c(min, max)
                }
            }

            color_domain
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
        },

        group_data_rows = function(){
            callSuper(params$color_groups, params$color_group_order)

            # We reverse it so the last color group gets the last color
            params$palette <<- rev(params$palette)
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
        }

    )
)

# Generates an interactive scatterplot
#
# x x-values, but only if the "y" param is specified, otherwise it represents the y-values. It can be a dataframe, a matrix, a vector, a list, or a factor (TODO test this).
# y y-values (optional)
# point_names point names
# title title of the plot
# main alias for title
# xlab,ylab x- and y-axis labels
# xlim,ylim x- and y-axis limits
# width,height width and height of the plot
# radius the radius of the points
# box draws a box around the plot
# palette color palette. Quantitative scales expect a vector with a start color, and an end color (optionally, a middle color may be provided between both). Categorical scales expect a vector with a color for each category. Use category names to change the default color assignment \code{c(category1="color1", category2="color2")}. The order in which these colors are specified determines rendering order when points from different categories collide (colors specified first appear on top of later ones). Colors can be a variety of formats: "#ffeeaa" "rgb(255,255,255)" "hsl(120,50%,20%)" "blue" (see http://www.w3.org/TR/SVG/types.html#ColorKeywords)
# col alias for palette
# color_groups a vector whose values are used to determine the color of the points. If it is a numeric vector, it will assume the scale is quantitative and it will generate a gradient using the start and end colors of the palette (also with the middle color, if it is provided). If it is a character vector, a logical vector, or a factor, it will generate a categorical scale with one color per unique value (or level).
# color_domain a vector with a start and end value (an optionally a middle value between them). It is only used for quantitative scales. Useful when the scale is continuous and, for example, we want to ensure it is symmetric in negative and positive values.
# color_title the title of the color legend
# extra a data frame, list or matrix whose fields will appear in the tooltip on hover
# padding padding around the top-level object
# ... additional arguments for \code{clickme}
#
clickme_helper$points <- function(x, y = NULL, ...){
    params <- list(x = x, y = y, ...)
    points <- Points$new(params)

    points$display()
}
