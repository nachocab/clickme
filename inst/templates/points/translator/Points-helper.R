Points$methods(

    get_color_legend_counts = function() {
        table(data$colorize)
    },

    # only for quantitative scales
    get_color_domain_param = function(){
        if (is.null(params$color_domain)){
            params$color_domain <<- range(data$colorize, na.rm = TRUE)
        }

        params$color_domain
    },

    get_d3_palette = function() {
        palette_names <- names(params$palette)
        categories <- unique(params$colorize)
        if (is.null(params$palette)){
            if (is.null(data$colorize) | length(unique(data$colorize)) == 1){
                    params$palette <<- c("#000")
            } else {
                if (scale_type(data$colorize) == "quantitative"){
                    params$palette <<- c("steelblue", "#CA0020") # blue-red gradient
                } else {
                    params$palette <<- rev(default_colors(length(categories)))
                }
            }
        }

        d3_palette <- toJSON(as.list(params$palette))
        d3_palette
    },

    get_d3_color_scale = function() {
        if (scale_type(data$colorize) == "quantitative") {
            color_scale <- paste0("d3.scale.linear()
                   .domain(", get_color_domain_param(), ")
                   .range(", get_palette_param(), ")
                   .interpolate(d3.interpolateLab);")
        } else {
            color_scale <- gettextf("d3.scale.ordinal().range(%s);", get_d3_palette())
        }

        color_scale
    }

)

# Generates an interactive scatterplot
#
# @param x x-values, but only if the "y" param is specified, otherwise it represents the y-values. It can be a dataframe, a matrix, a vector, a list, or a factor (TODO test this).
# @param y y-values (optional)
# @param point_names point names
# @param title title of the plot
# @param main alias for title
# @param xlab,ylab x- and y-axis labels
# @param xlim,ylim x- and y-axis limits
# @param width,height width and height of the plot
# @param radius the radius of the points
# @param box draws a box around the plot
# @param palette color palette. Quantitative scales expect a vector with a start color, and an end color (optionally, a middle color may be provided between both). Categorical scales expect a vector with a color for each category. Use category names to change the default color assignment \code{c(category1="color1", category2="color2")}. The order in which these colors are specified determines rendering order when points from different categories collide (colors specified first appear on top of later ones). Colors can be a variety of formats: "#ffeeaa" "rgb(255,255,255)" "hsl(120,50%,20%)" "blue" (see http://www.w3.org/TR/SVG/types.html#ColorKeywords)
# @param col alias for palette
# @param colorize a vector whose values are used to determine the color of the points. If it is a numeric vector, it will assume the scale is quantitative and it will generate a gradient using the start and end colors of the palette (also with the middle color, if it is provided). If it is a character vector, a logical vector, or a factor, it will generate a categorical scale with one color per unique value (or level).
# @param color_domain a vector with a start and end value (an optionally a middle value between them). It is only used for quantitative scales. Useful when the scale is continuous and, for example, we want to ensure it is symmetric in negative and positive values.
# @param color_title the title of the color legend
# @param extra a data frame, list or matrix whose fields will appear in the tooltip on hover
# @param padding padding around the top-level object
# @param ... additional arguments for \code{clickme}
#
clickme_helper$points <- function(x, y = NULL,
                          point_names = NULL,
                          xlim = NULL, ylim = NULL,
                          radius = 5,
                          jitter = 0,
                          ...){

    params <- extract_params()
    points <- Points$new(params)

    points$display()
}


