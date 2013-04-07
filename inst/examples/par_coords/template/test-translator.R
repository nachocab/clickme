context("translate par_coords")

test_that("the color_by parameter can be set manually", {
    opts <- get_opts("par_coords")
    opts$data <- data.frame(country=c("Spain", "Australia", "Philippines"), ice_cream_production=c(200,300,50), flamenco_appreciation_rate=c(1, .9, .6), beatles_records_sold=c(50,200,70))
    opts$params$color_by <- "flamenco_appreciation_rate"
    color_by <- get_color_by_param(opts)

    expected_color_by <- "flamenco_appreciation_rate"
    expect_equal(color_by, expected_color_by)
})

test_that("the color_by parameter is coerced if not present", {
    opts <- get_opts("par_coords")
    opts$data <- data.frame(country=c("Spain", "Australia", "Philippines"), ice_cream_production=c(200,300,50), flamenco_appreciation_rate=c(1, .9, .6), beatles_records_sold=c(50,200,70))
    coerced_color_by <- get_color_by_param(opts)

    expected_color_by <- "ice_cream_production"
    expect_equal(coerced_color_by, expected_color_by)
})

test_that("the color_by parameter matches an existing column name", {
    opts <- get_opts("par_coords")
    opts$data <- data.frame(country=c("Spain", "Australia", "Philippines"), ice_cream_production=c(200,300,50), flamenco_appreciation_rate=c(1, .9, .6), beatles_records_sold=c(50,200,70))
    opts$params$color_by <- "fake_column"
    expect_error(get_color_by_param(opts), "The input data doesn't contain a column named: fake_column")
})

test_that("the domain parameter is automatically calculated if not present", {
    opts <- get_opts("par_coords")
    opts$data <- data.frame(country=c("Spain", "Australia", "Philippines"), ice_cream_production=c(200,300,50), flamenco_appreciation_rate=c(1, .9, .6), beatles_records_sold=c(50,200,70))
    opts$params$color_by <- "ice_cream_production"
    coerced_domain <- get_domain_param(opts)

    expected_domain <- "50, 300"
    expect_equal(coerced_domain, expected_domain)
})

test_that("the domain parameter can be set manually", {
    opts <- get_opts("par_coords")
    opts$data <- data.frame(country=c("Spain", "Australia", "Philippines"), ice_cream_production=c(200,300,50), flamenco_appreciation_rate=c(1, .9, .6), beatles_records_sold=c(50,200,70))
    opts$params$domain <- c(2, 10)
    coerced_domain <- get_domain_param(opts)

    expected_domain <- "2, 10"
    expect_equal(coerced_domain, expected_domain)
})

test_that("input data is stored as a csv file", {
    test_data_name <- "test_data"
    opts <- get_opts("par_coords", data_name = test_data_name)
    opts$data <- data.frame(country=c("Spain", "Australia", "Philippines"), ice_cream_production=c(200,300,50), flamenco_appreciation_rate=c(1, .9, .6), beatles_records_sold=c(50,200,70))

    csv_file <- get_data_as_csv_file(opts)
    expect_correct_file(opts, "csv")
})
