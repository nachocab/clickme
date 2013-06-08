context("validate_ractive")

suppressMessages(set_templates_path(system.file("ractives", package="clickme")))

test_that("ractive is valid", {
    ractive <- "force_directed"
    opts <- get_opts(ractive, data_prefix = "data")

    opts$path$template <- "fake_template_path"
    expect_error(validate_ractive(opts), "template directory not found in:")
    opts <- get_opts(ractive, data_prefix = "data")

    opts$path$template_file <- "fake_template_file"
    expect_error(validate_ractive(opts), "template.Rmd not found in:")
    opts <- get_opts(ractive, data_prefix = "data")

    opts$path$config_file <- "fake_config_file"
    expect_error(validate_ractive(opts), "config.yml not found in:")
    opts <- get_opts(ractive, data_prefix = "data")

    opts$path$translator_file <- "fake_translator_file"
    expect_error(validate_ractive(opts), "translator.R not found in:")
    opts <- get_opts(ractive, data_prefix = "data")
})

# test_that("required packages require user confirmation before they are installed", {
#     set_templates_path(system.file("ractives", package="clickme"))
#     ractive <- "par_coords"
#     opts <- get_opts(ractive, data_prefix = "data")

#     opts$config$require_packages <- c("fake_package")
#     expect_message(validate_ractive(opts), "The par_coords ractive requires")
# })

test_that("styles and scripts must be valid", {
    ractive <- "par_coords"
    opts <- get_opts(ractive, data_prefix = "data")

    opts$config$styles <- c("abc.css")
    expect_error(validate_ractive(opts), "abc.css not found")

    opts <- get_opts(ractive, data_prefix = "data")
    opts$config$scripts <- c("abc.js")
    expect_error(validate_ractive(opts), "abc.js not found")

    opts <- get_opts(ractive, data_prefix = "data")
    opts$config$scripts <- c("http://d3js.org/d3.v3.min.js")
    expect_equal(validate_ractive(opts), opts)
})

test_that("require_server and require_coffeescript are false by default", {
    ractive <- "par_coords"
    opts <- get_opts(ractive, data_prefix = "data")

    opts$config$require_server <- NULL
    expect_false(validate_ractive(opts)$config$require_server)
})
