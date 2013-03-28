context("validate_ractive")

test_that("ractive is valid", {
    ractive <- "force_directed"
    set_root_path(system.file("examples", package="clickme"))
    opts <- get_opts(ractive, data_name = "data")

    opts$path$template <- "fake_template_path"
    expect_error(validate_ractive(opts), "template directory not found in:")
    opts <- get_opts(ractive, data_name = "data")

    opts$path$template_file <- "fake_template_file"
    expect_error(validate_ractive(opts), "template.Rmd not found in:")
    opts <- get_opts(ractive, data_name = "data")

    opts$path$template_config_file <- "fake_template_config_file"
    expect_error(validate_ractive(opts), "template_config.yml not found in:")
    opts <- get_opts(ractive, data_name = "data")

    opts$path$translator_file <- "fake_translator_file"
    expect_error(validate_ractive(opts), "translator.R not found in:")
    opts <- get_opts(ractive, data_name = "data")
})

# test_that("required packages require user confirmation before they are installed", {
#     set_root_path(system.file("examples", package="clickme"))
#     ractive <- "par_coords"
#     opts <- get_opts(ractive, data_name = "data")

#     opts$template_config$require_packages <- c("fake_package")
#     expect_message(validate_ractive(opts), "The par_coords ractive requires")
# })

test_that("styles and scripts must be valid", {
    set_root_path(system.file("examples", package="clickme"))
    ractive <- "par_coords"
    opts <- get_opts(ractive, data_name = "data")

    opts$template_config$styles <- c("abc.css")
    expect_error(validate_ractive(opts), "abc.css not found")

    opts <- get_opts(ractive, data_name = "data")
    opts$template_config$scripts <- c("abc.js")
    expect_error(validate_ractive(opts), "abc.js not found")

    opts <- get_opts(ractive, data_name = "data")
    opts$template_config$scripts <- c("http://d3js.org/d3.v3.min.js")
    expect_true(validate_ractive(opts))
})
