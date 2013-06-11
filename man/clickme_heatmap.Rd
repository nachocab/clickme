\name{clickme_heatmap}
\alias{clickme_heatmap}
\title{Generates an interactive heatmap}
\usage{
  clickme_heatmap(data, row_names = rownames(data),
    col_names = colnames(data), show_names = TRUE,
    show_row_names = show_names,
    show_col_names = show_names, title = NULL, main = NULL,
    cell_width = 20, cell_height = cell_width,
    row_groups = NULL, col_groups = NULL,
    palette = c("#278DD6", "#fff", "#d62728"),
    color_domain = NULL,
    padding = list(top = 80, right = 150, bottom = 30, left = 100),
    ...)
}
\arguments{
  \item{data}{matrix, data frame, or vector specifying
  y-values. A line is defined by the values of one row.}

  \item{row_names}{row names}

  \item{col_names}{column names}

  \item{title}{title of the plot}

  \item{main}{same as title, kept to be compatible with
  \code{base::plot}}

  \item{cell_width,cell_height}{width and height of a cell}

  \item{row_groups,col_groups}{row and column groups}

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

  \item{color_domain}{a vector with a start and end value
  (an optionally a middle value between them). By default
  it is symmetric c(-max, 0, max)}

  \item{padding}{padding around the top-level object}

  \item{...}{additional arguments for \code{clickme}}
}
\description{
  Generates an interactive heatmap
}
\examples{
clickme_heatmap(matrix(rnorm(700), ncol = 10), row_names = paste("row", 1:70))
}

