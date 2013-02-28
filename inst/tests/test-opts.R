context("add_paths")

library(yaml)

test_that("error when the template doesn't exist", {
    data <- mat()
    expect_error(add_paths(data, "non_existant_template"))
})

test_that("default options", {

    data <- data.frame(logFC=c(1,2,3), y=c(.01,.1,.009))
    clickme_path(system.file("demo", package="clickme"))
    opts <- list(data=data, template_id="force_directed", data_name="data")
    opts <- add_paths(opts)

    expect_equal(opts$template_path, file.path(.clickme_env$path, .clickme_env$templates_dir_name, opts$template_id, .clickme_env$template_file_name))
    expect_equal(opts$config_path, file.path(.clickme_env$path, .clickme_env$templates_dir_name, opts$template_id, .clickme_env$config_file_name))

    expect_equal(opts$relative_data_path, file.path(.clickme_env$templates_dir_name, opts$template_id, .clickme_env$data_dir_name))
    expect_equal(opts$relative_translator_path, file.path(.clickme_env$templates_dir_name, opts$template_id, .clickme_env$translator_dir_name))
    expect_equal(opts$relative_scripts_path, file.path(.clickme_env$templates_dir_name, opts$template_id, .clickme_env$scripts_dir_name))
    expect_equal(opts$relative_styles_path, file.path(.clickme_env$templates_dir_name, opts$template_id, .clickme_env$styles_dir_name))

    expect_equal(opts$viz_path, file.path(.clickme_env$path, "data-force_directed.html"))

})

context("template_config")

test_that("config is correctly loaded", {
        data <- data.frame(logFC=c(1,2,3), y=c(.01,.1,.009))
        clickme_path(system.file("demo", package="clickme"))

        opts <- list(data=data, template_id="force_directed")
        opts <- add_paths(opts)
        opts$template_config <- get_template_config(opts)

        expect_true(is.numeric(opts$template_config$width))
        expect_true(is.numeric(opts$template_config$height))
        expect_true(is.character(opts$template_config$scripts))
        expect_true(is.character(opts$template_config$styles))
})