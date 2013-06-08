context("validate_template")


test_that("template is valid", {
    template <- "force_directed"
    opts <- get_opts(template, data_prefix = "data")

    opts$path$template <- "fake_template_path"
    expect_error(validate_template(opts), "template directory not found in:")
    opts <- get_opts(template, data_prefix = "data")

    opts$path$template_file <- "fake_template_file"
    expect_error(validate_template(opts), "template.Rmd not found in:")
    opts <- get_opts(template, data_prefix = "data")

    opts$path$config_file <- "fake_config_file"
    expect_error(validate_template(opts), "config.yml not found in:")
    opts <- get_opts(template, data_prefix = "data")

    opts$path$translator_file <- "fake_translator_file"
    expect_error(validate_template(opts), "translator.R not found in:")
    opts <- get_opts(template, data_prefix = "data")
})

test_that("styles and scripts must be valid", {
    template <- "par_coords"
    opts <- get_opts(template, data_prefix = "data")

    opts$config$styles <- c("abc.css")
    expect_error(validate_template(opts), "abc.css not found")

    opts <- get_opts(template, data_prefix = "data")
    opts$config$scripts <- c("abc.js")
    expect_error(validate_template(opts), "abc.js not found")

    opts <- get_opts(template, data_prefix = "data")
    opts$config$scripts <- c("http://d3js.org/d3.v3.min.js")
    expect_equal(validate_template(opts), opts)
})

test_that("require_server and require_coffeescript are false by default", {
    template <- "par_coords"
    opts <- get_opts(template, data_prefix = "data")

    opts$config$require_server <- NULL
    expect_false(validate_template(opts)$config$require_server)
})
