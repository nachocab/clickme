context("translate lines")

opts <- get_opts("lines")

test_that("the scales are categorical or quantitative", {
    data_df <- data.frame(x1 = 1:3, x2 = 4:6, x3 = 7:9, row.names = letters[1:3])
    params$x <- colnames(data_df)
    opts$data <- get_lines_data(data_df, params$x, list(list_names = rownames(data_df)))
    x_scale <- get_d3_x_scale(opts)
    expect_equal(strwrap(x_scale), strwrap("d3.scale.ordinal()
                                    .domain([\"x1\",\"x2\",\"x3\"])
                                    .rangePoints([0, plot.width], .1)"))

    y_scale <- get_d3_y_scale(opts)
    expect_equal(strwrap(y_scale), strwrap("d3.scale.linear()
                                    .domain([1,9])
                                    .range([plot.height, 0])"))

    params$x <- 1:3
    opts$data <- get_lines_data(data_df, params$x, list(list_names = rownames(data_df)))
    x_scale <- get_d3_x_scale(opts)
    expect_equal(strwrap(x_scale), strwrap("d3.scale.linear()
                                    .domain([1,3])
                                    .range([0, plot.width])"))

})

test_that("the palette has as many colors as levels (or unique elements) in colorize", {
    data_df <- data.frame(x1 = 1:3, x2 = 4:6, x3 = 7:9, row.names = letters[1:3])
    params$x <- colnames(data_df)
    opts$data <- get_lines_data(data_df, params$x, list(line_names = rownames(data_df), colorize = c("a", "a", "b")))

    palette <- get_palette_param(opts)
    expect_equal(length(fromJSON(palette)), 2)
})

test_that("color_legend_counts has the right counts", {
    opts$data <- get_lines_data(mat(nrow=5,ncol=5), 1:5, list(colorize = c("a","a","b","b","a")))
    color_legend_counts <- get_color_legend_counts(opts)
    expect_equal(list(a=3, b =2), fromJSON(color_legend_counts))
})