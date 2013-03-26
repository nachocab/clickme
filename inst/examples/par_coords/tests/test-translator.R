context("translate par_coords")

test_that("the color_by parameter is coerced if not present", {
    input_data <- data.frame(country=c("Spain", "Australia", "Philippines"), ice_cream_production=c(200,300,50), flamenco_appreciation_rate=c(1, .9, .6), beatles_records_sold=c(50,200,70))
    opts <- get_opts("par_coords")
    opts <- coerce_parameters(input_data, opts)

    expected_color_by <- "ice_cream_production"
    expect_equal(expected_color_by, opts$params$color_by)
})

test_that("the color_by parameter can be set manually", {
    input_data <- data.frame(country=c("Spain", "Australia", "Philippines"), ice_cream_production=c(200,300,50), flamenco_appreciation_rate=c(1, .9, .6), beatles_records_sold=c(50,200,70))
    opts <- get_opts("par_coords")
    opts$params$color_by <- "flamenco_appreciation_rate"
    opts <- coerce_parameters(input_data, opts)

    expected_color_by <- "flamenco_appreciation_rate"
    expect_equal(expected_color_by, opts$params$color_by)
})

test_that("the color_by parameter matches an existing column name", {
    input_data <- data.frame(country=c("Spain", "Australia", "Philippines"), ice_cream_production=c(200,300,50), flamenco_appreciation_rate=c(1, .9, .6), beatles_records_sold=c(50,200,70))
    opts <- get_opts("par_coords")
    opts$params$color_by <- "fake_column"
    expect_error(coerce_parameters(input_data, opts), "The input data doesn't contain a column named: fake_column")
})

test_that("the range parameter is automatically calculated if not present", {
    input_data <- data.frame(country=c("Spain", "Australia", "Philippines"), ice_cream_production=c(200,300,50), flamenco_appreciation_rate=c(1, .9, .6), beatles_records_sold=c(50,200,70))
    opts <- get_opts("par_coords")
    opts$params$color_by <- "ice_cream_production"
    opts <- coerce_parameters(input_data, opts)

    expected_range <- "50, 300"
    expect_equal(expected_range, opts$params$range)
})

test_that("the range parameter can be set manually", {
    input_data <- data.frame(country=c("Spain", "Australia", "Philippines"), ice_cream_production=c(200,300,50), flamenco_appreciation_rate=c(1, .9, .6), beatles_records_sold=c(50,200,70))
    opts <- get_opts("par_coords")
    opts$params$range <- c(2, 10)
    opts <- coerce_parameters(input_data, opts)

    expected_range <- "2, 10"
    expect_equal(expected_range, opts$params$range)
})

test_that("input data is stored as a csv file", {
    input_data <- data.frame(country=c("Spain", "Australia", "Philippines"), ice_cream_production=c(200,300,50), flamenco_appreciation_rate=c(1, .9, .6), beatles_records_sold=c(50,200,70))

    test_data_name <- "test_data"
    opts <- get_opts("par_coords", data_name = test_data_name)
    opts <- translate(input_data, opts)
    expected_data <- paste0("\"", file.path(opts$relative_path$data, paste0(test_data_name, ".csv")), "\"")

    expect_equal(opts$data, expected_data)
    expect_true(file.exists(file.path(opts$path$data, paste0(test_data_name, ".csv"))))

    unlink(file.path(opts$path$data, paste0(test_data_name, ".csv")))
})
