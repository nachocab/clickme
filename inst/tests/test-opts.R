library(yaml)

context("opts")

test_that("the ractive folder must exist", {
    expect_error(get_opts("fake_ractive"), "No ractive named fake_ractive found at")
})

test_that("the config file must exist", {
    fake_ractive_path <- file.path(system.file("ractives", package = "clickme"), "fake_ractive")
    dir.create(fake_ractive_path)

    expect_error(get_opts("fake_ractive", data_prefix = "data"), "No template configuration file found")

    unlink(fake_ractive_path, recursive = TRUE)
})

suppressMessages(set_templates_path(system.file("ractives", package="clickme")))

test_that("add ractive options", {
    opts <- add_ractive_opts("force_directed")
    expect_equal(opts$path$ractive, file.path(get_templates_path(), opts$name$ractive))
    expect_equal(opts$path$data, file.path(opts$path$ractive, opts$name$data))
    expect_equal(opts$path$external, file.path(opts$path$ractive, opts$name$external))
    expect_equal(opts$path$template, file.path(opts$path$ractive, opts$name$template))

    expect_equal(opts$path$config_file, file.path(opts$path$template, opts$name$config_file))
    expect_equal(opts$path$template_file, file.path(opts$path$template, opts$name$template_file))
    expect_equal(opts$path$translator_file, file.path(opts$path$template, opts$name$translator_file))
    expect_equal(opts$path$translator_test_file, file.path(opts$path$template, opts$name$translator_test_file))

    expect_equal(opts$relative_path$data, file.path(opts$name$ractive, opts$name$data))
    expect_equal(opts$relative_path$external, file.path(opts$name$ractive, opts$name$external))
})

test_that("data_prefix is data by default, and it appends random string when NULL", {
    opts <- get_opts("force_directed")
    expect_equal(opts$data_prefix, "data")

    opts <- get_opts("force_directed", data_prefix = NULL)
    expect_match(opts$data_prefix, "data[0-9a-z]+")
})

opts <- get_opts("force_directed")
test_that("the output HTML file is named using the data_prefix and the ractive name", {
    expect_equal(opts$name$html_file, paste0(opts$data_prefix, "-", opts$name$ractive, ".html"))
    expect_equal(opts$path$html_file, file.path(get_templates_path(), opts$name$html_file))
})

test_that("name_mappings gets saved", {
    name_mappings <- c(my_source = "source")
    opts <- get_opts("force_directed", name_mappings = name_mappings)
    expect_equal(opts$name_mappings, name_mappings)
})

test_that("opts$url is set", {
    expect_equal(opts$url, opts$path$html_file)

    opts <- get_opts("par_coords")
    expect_equal(opts$url, "http://localhost:8000/data-par_coords.html")
})

test_that("user params override template params", {
    opts <- get_opts("force_directed", params = list(height = 666))
    expect_equal(opts$params$height, 666)
})
