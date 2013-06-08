\name{clickme_lines}
\alias{clickme_lines}
\title{Generates an intetemplate line plot}
\usage{
  clickme_lines(data, x = colnames(data),
    line_names = rownames(data), lwd = 3,
    interpolate = "linear", title = "Lines", main = NULL,
    xlab = NULL, ylab = NULL, width = 980, height = 980,
    box = NULL, palette = NULL, colorize = NULL,
    color_domain = NULL, color_legend_title = NULL,
    padding = list(top = 80, right = 400, bottom = 30, left = 100),
    ...)
}
\arguments{
  \item{data}{matrix, data frame, or vector specifying
  y-values. A line is defined by the values of one row.}

  \item{x}{x-values (optional). If specified by a numeric
  vector, it is used to set the tick values.}

  \item{line_names}{line names}

  \item{lwd}{line width}

  \item{interpolate}{interpolation mode. Values linear
  (default), basis, cardinal and more:
  https://github.com/mbostock/d3/wiki/SVG-Shapes#wiki-line_interpolate}

  \item{title}{title of the plot}

  \item{main}{same as title, kept to be compatible with
  \code{base::plot}}

  \item{xlab,ylab}{x- and y-axis labels}

  \item{width,height}{width and height of the plot}

  \item{box}{draw a box around the plot}

  \item{palette}{color palette. Quantitative scales expect
  a vector with a start color, and an end color
  (optionally, a middle color may be provided between
  both). Categorical scales expect a vector with a color
  for each category. Use category names to change the
  default color assignment \code{c(category1="color1",
  category2="color2")}. The order in which these colors are
  specified determines rendering order when points from
  different categories collide (colors specified first
  appear on top of later ones). Colors can be a variety of
  formats: "#ffeeaa" "rgb(255,255,255)" "hsl(120,50%,20%)"
  "blue" (see
  http://www.w3.org/TR/SVG/types.html#ColorKeywords)}

  \item{colorize}{a vector whose values are used to
  determine the color of the points. If it is a numeric
  vector, it will assume the scale is quantitative and it
  will generate a gradient using the start and end colors
  of the palette (also with the middle color, if it is
  provided). If it is a character vector, a logical vector,
  or a factor, it will generate a categorical scale with
  one color per unique value (or level).}

  \item{color_domain}{a vector with a start and end value
  (an optionally a middle value between them). It is only
  used for quantitative scales. Useful when the scale is
  continuous and, for example, we want to ensure it is
  symmetric in negative and positive values.}

  \item{color_legend_title}{the title of the color legend}

  \item{padding}{padding around the top-level object}

  \item{...}{additional arguments for \code{clickme}}
}
\description{
  Generates an intetemplate line plot
}

