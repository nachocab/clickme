context("translate points")

opts <- get_opts("points")
opts$data <- data.frame(a = 1:5)

test_that("the palette is black when colorize is NULL or it has length 1", {
    palette <- get_palette_param(opts)
    expect_equal(palette, "[\"#000\"]")

    opts$data$colorize__ <- "a"
    palette <- get_palette_param(opts)
    expect_equal(palette, "[\"#000\"]")
})

test_that("the palette has as many colors as levels (or unique elements) in colorize", {
    opts$data$colorize__ <- c("a", "a", "b", "c", "b")
    palette <- get_palette_param(opts)
    expect_equal(length(fromJSON(palette)), 3)
})

test_that("the palette can be set manually", {
    opts$params$palette <- c("#000","blue")
    palette <- get_palette_param(opts)

    expect_equal(palette, toJSON(opts$params$palette))
})


    # data <- get_points_data(1:5, NULL, params)


test_that("the d3_color_scale can be categorical or quantitative", {
    opts$data$colorize__ <- c(1:5)
    color_scale <- get_d3_color_scale(opts)

    expected_color_scale <- "d3.scale.linear().domain([1,5]).range([\"steelblue\",\"#CA0020\"]).interpolate(d3.interpolateLab);"
    expect_equal(gsub("\\s","", color_scale), expected_color_scale)

    opts$data$colorize__ <- c("a", "a", "b", "c", "b")
    color_scale <- get_d3_color_scale(opts)

    expected_color_scale <- "d3.scale.ordinal().range([\"#1f77b4\",\"#d62728\",\"#2ca02c\"]);"
    expect_equal(gsub("\\s","", color_scale), expected_color_scale)
})

test_that("the color_domain is calculated from the values of colorize", {
    opts$data$colorize__ <- c(1, NA, 3, 5, 4)
    color_domain <- get_color_domain_param(opts)

    expect_equal(color_domain, "[1,5]")
})

test_that("the color_domain parameter can be set manually", {
    opts$params$color_domain <- c(2, 10)
    color_domain <- get_color_domain_param(opts)

    expect_equal(color_domain, "[2,10]")
})




