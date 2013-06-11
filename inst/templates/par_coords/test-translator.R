context("translate par_coords")

opts <- get_opts("par_coords")
opts$data <- data.frame(country = c("Spain", "Australia", "Philippines"),
                        ice_cream_production = c(200, 300, 50),
                        flamenco_appreciation_rate = c(1, .9, .6),
                        beatles_records_sold = c(50, 200, 70))

test_that("the color_by parameter can be set manually", {
    opts$params$color_by <- "flamenco_appreciation_rate"
    color_by <- get_color_by_param(opts)

    expected_color_by <- "flamenco_appreciation_rate"
    expect_equal(color_by, expected_color_by)
})

test_that("the color_by parameter matches an existing column name", {
    opts$params$color_by <- "fake_column"
    expect_error(get_color_by_param(opts), "The input data doesn't contain a column named: fake_column")
})

test_that("the color_by parameter is coerced to the first column if not present", {
    coerced_color_by <- get_color_by_param(opts)

    expected_color_by <- "country"
    expect_equal(coerced_color_by, expected_color_by)
})

test_that("the domain parameter can be set manually", {
    opts$params$domain <- c(2, 10)
    domain <- get_domain_param(opts)

    expected_domain <- "[2,10]"
    expect_equal(domain, expected_domain)
})

test_that("the domain data doesn't contain any NAs", {
    old_data <- opts$data
    opts$data$flamenco_appreciation_rate[3] <- NA
    opts$params$color_by <- "flamenco_appreciation_rate"
    domain <- get_domain_param(opts)

    expected_domain <- "[0.9,1]"
    expect_equal(domain, expected_domain)
    opts$data <- old_data
})

test_that("the domain parameter is automatically calculated if not present", {
    opts$params$color_by <- "ice_cream_production"
    coerced_domain <- get_domain_param(opts)

    expected_domain <- "[50,300]"
    expect_equal(coerced_domain, expected_domain)

    opts$params$color_by <- "country"
    coerced_domain <- get_domain_param(opts)

    expected_domain <- "[1,3]"
    expect_equal(coerced_domain, expected_domain)
})

test_that("colors can be set manually", {
    opts$params$colors <- c("#000","blue")
    colors <- get_colors_param(opts)

    expected_colors <- "[\"#000\",\"blue\"]"
    expect_equal(colors, expected_colors)
})

test_that("the colors parameter is coerced if not present", {
    opts$params$color_by <- "ice_cream_production"
    coerced_colors <- get_colors_param(opts)

    expected_colors <- "[\"steelblue\",\"brown\"]"
    expect_equal(coerced_colors, expected_colors)

    opts$params$color_by <- "country"
    coerced_colors <- get_colors_param(opts)

    expected_colors <- "[\"#1f77b4\",\"#ff7f0e\",\"#2ca02c\",\"#d62728\",\"#9467bd\",\"#8c564b\",\"#e377c2\",\"#7f7f7f\",\"#bcbd22\",\"#17becf\",\"#aec7e8\",\"#ffbb78\",\"#98df8a\",\"#ff9896\",\"#c5b0d5\",\"#c49c94\",\"#f7b6d2\",\"#c7c7c7\",\"#dbdb8d\",\"#9edae5\"]"
    expect_equal(coerced_colors, expected_colors)
})

test_that("the color_scale can be categorical or quantitative", {
    opts$params$color_by <- "flamenco_appreciation_rate"
    color_scale <- get_color_scale(opts)

    expected_color_scale <- "d3.scale.linear().domain([0.6,1]).range([\"steelblue\",\"brown\"]).interpolate(d3.interpolateLab);"
    expect_equal(gsub("\\s","", color_scale), expected_color_scale)

    opts$params$color_by <- "country"
    color_scale <- get_color_scale(opts)

    expected_color_scale <- "d3.scale.ordinal().range([\"#1f77b4\",\"#ff7f0e\",\"#2ca02c\",\"#d62728\",\"#9467bd\",\"#8c564b\",\"#e377c2\",\"#7f7f7f\",\"#bcbd22\",\"#17becf\",\"#aec7e8\",\"#ffbb78\",\"#98df8a\",\"#ff9896\",\"#c5b0d5\",\"#c49c94\",\"#f7b6d2\",\"#c7c7c7\",\"#dbdb8d\",\"#9edae5\"]);"
    expect_equal(gsub("\\s","", color_scale), expected_color_scale)
})

test_that("input data is stored as a csv file", {
    test_data_prefix <- "test_data"
    opts <- get_opts("par_coords", data_prefix = test_data_prefix)
    opts$data <- data.frame(country = c("Spain", "Australia", "Philippines"), ice_cream_production = c(200, 300, 50), flamenco_appreciation_rate = c(1, .9, .6), beatles_records_sold = c(50, 200, 70))

    csv_file <- get_data_as_csv_file(opts)
    expect_correct_file(opts, "csv")
})
