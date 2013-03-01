library(yaml)

context("opts")

test_that("initialize options", {
    set_root_path(system.file("demo", package="clickme"))
    opts <- initialize_opts()
    expect_equal(opts$path$templates, file.path(get_root_path(), opts$name$templates))
})

test_that("add template options", {
    set_root_path(system.file("demo", package="clickme"))
    opts <- add_template_opts("force_directed")
    expect_equal(opts$path$template_id, file.path(opts$path$templates, opts$name$template_id))
    expect_equal(opts$path$translator, file.path(opts$path$template_id, opts$name$translator))
    expect_equal(opts$path$data, file.path(opts$path$template_id, opts$name$data))
    expect_equal(opts$path$styles, file.path(opts$path$template_id, opts$name$styles))
    expect_equal(opts$path$scripts, file.path(opts$path$template_id, opts$name$scripts))

    expect_equal(opts$path$translator_file, file.path(opts$path$translator, opts$name$translator_file))
    expect_equal(opts$path$config_file, file.path(opts$path$template_id, opts$name$config_file))
    expect_equal(opts$path$template_file, file.path(opts$path$template_id, opts$name$template_file))

    expect_equal(opts$relative_path$template_id, file.path(opts$name$templates, opts$name$template_id))
    expect_equal(opts$relative_path$data, file.path(opts$relative_path$template_id, opts$name$data))
    expect_equal(opts$relative_path$scripts, file.path(opts$relative_path$template_id, opts$name$scripts))
    expect_equal(opts$relative_path$styles, file.path(opts$relative_path$template_id, opts$name$styles))
})

test_that("add visualization options", {
    set_root_path(system.file("demo", package="clickme"))
    opts <- get_opts("force_directed", data_file_name = "data")

    expect_equal(opts$name$viz_file, paste0(opts$name$data_file, "-", opts$name$template_id, ".html"))
    expect_equal(opts$path$viz_file, file.path(get_root_path(), "data-force_directed.html"))
})


test_that("get_template_config", {
        set_root_path(system.file("demo", package="clickme"))
        opts <- get_opts("force_directed")

        expect_true(is.numeric(opts$template_config$width))
        expect_true(is.numeric(opts$template_config$height))
        expect_true(is.character(opts$template_config$scripts))
        expect_true(is.character(opts$template_config$styles))
})