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