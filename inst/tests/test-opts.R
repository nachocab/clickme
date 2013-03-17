library(yaml)

context("opts")

test_that("add ractive options", {
    set_root_path(system.file("examples", package="clickme"))
    opts <- add_ractive_opts("force_directed")
    expect_equal(opts$path$ractive, file.path(get_root_path(), opts$name$ractive))
    expect_equal(opts$path$data, file.path(opts$path$ractive, opts$name$data))
    expect_equal(opts$path$external, file.path(opts$path$ractive, opts$name$external))
    expect_equal(opts$path$template, file.path(opts$path$ractive, opts$name$template))

    expect_equal(opts$path$template_config_file, file.path(opts$path$template, opts$name$template_config_file))
    expect_equal(opts$path$template_file, file.path(opts$path$template, opts$name$template_file))
    expect_equal(opts$path$translator_file, file.path(opts$path$template, opts$name$translator_file))

    expect_equal(opts$relative_path$data, file.path(opts$name$ractive, opts$name$data))
    expect_equal(opts$relative_path$external, file.path(opts$name$ractive, opts$name$external))
})

test_that("add visualization options", {
    set_root_path(system.file("examples", package="clickme"))
    opts <- get_opts("force_directed")

    expect_equal(opts$path$data_file, file.path(opts$path$data, opts$name$data_file))
    expect_equal(opts$name$html_file, paste0(strsplit(opts$name$data_file, "\\.")[[1]][1], "-", opts$name$ractive, ".html"))
    expect_equal(opts$path$html_file, file.path(get_root_path(), opts$name$html_file))
})


test_that("get template configuration", {
        set_root_path(system.file("examples", package="clickme"))
        opts <- get_opts("force_directed")

        expect_true(is.character(opts$template_config$valid_names))
        expect_true(is.character(opts$template_config$require))
        expect_true(is.numeric(opts$template_config$width))
        expect_true(is.numeric(opts$template_config$height))
        expect_true(is.character(opts$template_config$scripts))
        expect_true(is.character(opts$template_config$styles))
        expect_false(opts$template_config$server)
})
