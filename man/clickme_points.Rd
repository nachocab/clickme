\name{clickme_points}
\alias{clickme_points}
\title{Generates an interactive scatterplot}
\usage{
  clickme_points(x, y = NULL, point_names = rownames(x),
    title = "Points", main = NULL, xlab = "x", ylab = "y",
    xlim = NULL, ylim = NULL, width = 980, height = 980,
    radius = 5, box = FALSE, jitter = 0, extra = NULL,
    palette = NULL, colorize = NULL, color_domain = NULL,
    color_title = NULL,
    padding = list(top = 80, right = 400, bottom = 30, left = 100),
    ...)
}
\arguments{
  \item{x}{x-values, but only if the "y" param is
  specified, otherwise it represents the y-values. It can
  be a dataframe, a matrix, a vector, a list, or a factor
  (TODO test this).}

  \item{y}{y-values (optional)}

  \item{point_names}{point names}

  \item{title}{title of the plot}

  \item{main}{same as title, kept to be compatible with
  \code{base::plot}}

  \item{xlab,ylab}{x- and y-axis labels}

  \item{xlim,ylim}{x- and y-axis limits}

  \item{width,height}{width and height of the plot}

  \item{radius}{the radius of the points}

  \item{box}{draws a box around the plot}

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

  \item{color_title}{the title of the color legend}

  \item{extra}{a data frame, list or matrix whose fields
  will appear in the tooltip on hover}

  \item{padding}{padding around the top-level object}

  \item{...}{additional arguments for \code{clickme}}
}
\description{
  Generates an interactive scatterplot
}

