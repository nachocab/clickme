context("add_paths")

library(yaml)

test_that("error when the template doesn't exist", {
    data <- mat()
    expect_error(add_paths(data, "non_existant_template"))
})

test_that("default options", {

    data <- data.frame(logFC=c(1,2,3), y=c(.01,.1,.009))
    set_root_path(system.file("demo", package="clickme"))
    opts <- list(data=data, template_id="force_directed_local", name$data="data")
    opts <- add_paths(opts)

    expect_equal(opts$path$template_id, file.path(.clickme_env$path, .clickme_env$name$templates, opts$name$template_id))
    expect_equal(opts$path$template_file, file.path(opts$path$template_id, .clickme_env$name$template_file))
    expect_equal(opts$path$config_file, file.path(opts$path$template_id, .clickme_env$name$config_file))

    expect_equal(opts$relative_path$data, file.path(.clickme_env$name$templates, opts$name$template_id, .clickme_env$name$data))
    expect_equal(opts$relative_path$translator, file.path(.clickme_env$name$templates, opts$name$template_id, .clickme_env$name$translator))
    expect_equal(opts$relative_path$scripts, file.path(.clickme_env$name$templates, opts$name$template_id, .clickme_env$name$scripts))
    expect_equal(opts$relative_path$styles, file.path(.clickme_env$name$templates, opts$name$template_id, .clickme_env$name$styles))

    expect_equal(opts$path$viz_file, file.path(.clickme_env$path, "data-force_directed_local.html"))

})

context("template_config")

test_that("config is correctly loaded", {
        data <- data.frame(logFC=c(1,2,3), y=c(.01,.1,.009))
        set_root_path(system.file("demo", package="clickme"))

        opts <- list(data=data, template_id="force_directed_local")
        opts <- add_paths(opts)
        opts$template_config <- get_template_config(opts)

        expect_true(is.numeric(opts$template_config$width))
        expect_true(is.numeric(opts$template_config$height))
        expect_true(is.character(opts$template_config$scripts))
        expect_true(is.character(opts$template_config$styles))
})