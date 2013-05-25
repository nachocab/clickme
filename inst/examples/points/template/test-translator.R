context("translate points")

opts <- get_opts("points")
opts$data <- data.frame(ice_cream_production = c(200, 300, 50),
                        flamenco_appreciation_rate = c(1, .9, .6),
                        beatles_records_sold = c(50, 200, 70),
                        country = c("Spain", "Australia", "Philippines"))


test_that("the color_name parameter can be set manually", {
    opts$params$color_name <- "flamenco_appreciation_rate"
    color_name <- get_color_name_param(opts)

    expected_color_name <- "flamenco_appreciation_rate"
    expect_equal(color_name, expected_color_name)
})

test_that("the color_name parameter matches an existing column name", {
    opts$params$color_name <- "fake_column"
    expect_error(get_color_name_param(opts), "fake_column")
})

test_that("the color_name parameter is coerced to the first column if not present", {
    coerced_color_name <- get_color_name_param(opts)

    expected_color_name <- "country"
    expect_equal(coerced_color_name, expected_color_name)
})

test_that("the domain parameter can be set manually", {
    opts$params$domain <- c(2, 10)
    domain <- get_color_domain_param(opts)

    expected_domain <- "[2,10]"
    expect_equal(domain, expected_domain)
})

test_that("the domain data doesn't contain any NAs", {
    old_data <- opts$data
    opts$data$flamenco_appreciation_rate[2] <- NA
    opts$params$color_name <- "flamenco_appreciation_rate"
    domain <- get_color_domain_param(opts)

    expected_domain <- "[0.6,1]"
    expect_equal(domain, expected_domain)
    opts$data <- old_data
})

test_that("the domain parameter is automatically calculated if not present", {
    opts$params$color_name <- "ice_cream_production"
    coerced_domain <- get_color_domain_param(opts)

    expected_domain <- "[50,300]"
    expect_equal(coerced_domain, expected_domain)

    opts$params$color_name <- "country"
    coerced_domain <- get_color_domain_param(opts)

    expected_domain <- "[1,3]"
    expect_equal(coerced_domain, expected_domain)
})

test_that("the palette can be set manually", {
    opts$params$palette <- c("#000","blue")
    palette <- get_palette_param(opts)

    expected_palette <- "[\"#000\",\"blue\"]"
    expect_equal(palette, expected_palette)
})

test_that("the colors parameter is coerced if not present", {
    opts$params$color_name <- "ice_cream_production"
    coerced_palette <- get_palette_param(opts)

    expected_palette <- "[\"steelblue\",\"#CA0020\"]"
    expect_equal(coerced_palette, expected_palette)

    opts$params$color_name <- "country"
    coerced_palette <- get_palette_param(opts)

    expected_palette <- "[\"#1f77b4\",\"#d62728\",\"#2ca02c\"]"
    expect_equal(coerced_palette, expected_palette)
})

test_that("the color_scale can be categorical or quantitative", {
    opts$params$color_name <- "flamenco_appreciation_rate"
    color_scale <- get_d3_color_scale(opts)

    expected_color_scale <- "d3.scale.linear().domain([0.6,1]).range([\"steelblue\",\"#CA0020\"]).interpolate(d3.interpolateLab);"
    expect_equal(gsub("\\s","", color_scale), expected_color_scale)

    opts$params$color_name <- "country"
    color_scale <- get_d3_color_scale(opts)

    expected_color_scale <- "d3.scale.ordinal().range([\"#1f77b4\",\"#d62728\",\"#2ca02c\"]);"
    expect_equal(gsub("\\s","", color_scale), expected_color_scale)
})

test_that("if color_name only has one value, use black", {
    opts2 <- get_opts("points")
    opts2$data <- data.frame(ice_cream_production = c(200, 300, 50),
                            flamenco_appreciation_rate = c(1, .9, .6),
                            beatles_records_sold = c(50, 200, 70),
                            country = "Spain")

    opts2$params$color_name <- "country"

    coerced_palette <- get_palette_param(opts2)
    expected_palette <- "[\"#000\"]"
    expect_equal(coerced_palette, expected_palette)
})
