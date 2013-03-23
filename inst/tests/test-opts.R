library(yaml)

context("opts")

test_that("the ractive folder must exist", {
    expect_error(get_opts("fake_ractive", data_name = "data"), "No ractive named fake_ractive found at")
})

test_that("the template_config file must exist", {
    fake_ractive_path <- file.path(system.file("examples", package = "clickme"), "fake_ractive")
    dir.create(fake_ractive_path)

    expect_error(get_opts("fake_ractive", data_name = "data"), "No template configuration file found")

    unlink(fake_ractive_path, recursive = TRUE)
})

test_that("add ractive options", {
    set_root_path(system.file("examples", package="clickme"))
    opts <- add_ractive_opts("force_directed")
    expect_equal(opts$path$ractive, file.path(get_root_path(), opts$name$ractive))
    expect_equal(opts$path$data, file.path(opts$path$ractive, opts$name$data))
    expect_equal(opts$path$external, file.path(opts$path$ractive, opts$name$external))
    expect_equal(opts$path$template, file.path(opts$path$ractive, opts$name$template))
    expect_equal(opts$path$tests, file.path(opts$path$ractive, opts$name$tests))

    expect_equal(opts$path$template_config_file, file.path(opts$path$template, opts$name$template_config_file))
    expect_equal(opts$path$template_file, file.path(opts$path$template, opts$name$template_file))
    expect_equal(opts$path$translator_file, file.path(opts$path$template, opts$name$translator_file))
    expect_equal(opts$path$translator_test_file, file.path(opts$path$tests, opts$name$translator_test_file))

    expect_equal(opts$relative_path$data, file.path(opts$name$ractive, opts$name$data))
    expect_equal(opts$relative_path$external, file.path(opts$name$ractive, opts$name$external))
})

test_that("add visualization options", {
    set_root_path(system.file("examples", package="clickme"))
    opts <- get_opts("force_directed", data_name="data")

    expect_equal(opts$data_name, "data")
    expect_equal(opts$name$html_file, paste0(opts$data_name, "-", opts$name$ractive, ".html"))
    expect_equal(opts$path$html_file, file.path(get_root_path(), opts$name$html_file))
})


test_that("get template configuration", {
        set_root_path(system.file("examples", package="clickme"))
        opts <- get_opts("force_directed")

        expect_true(is.character(opts$template_config$valid_names))
        expect_true(is.character(opts$template_config$require_packages))
        expect_true(is.character(opts$template_config$scripts))
        expect_true(is.character(opts$template_config$styles))
        expect_false(opts$template_config$require_server)

        expect_true(is.numeric(opts$params$width))
        expect_true(is.numeric(opts$params$height))
})

test_that("user params override template params", {
    set_root_path(system.file("examples", package="clickme"))
    opts <- get_opts("force_directed")
    expect_equal(opts$params$height, 800)

    opts <- get_opts("force_directed", params=list(height=666))
    expect_equal(opts$params$height, 666)
})


test_that("user params are valid", {
    set_root_path(system.file("examples", package="clickme"))
    expect_error(get_opts("force_directed", params=list(fake_param=666)), "fake_param is not a valid parameter")
})