context("populate_opts")

library(yaml)

test_that("error when the template doesn't exist", {
    data <- mat()
    expect_error(populate_opts(data, "non_existant_template"))
})

test_that("default options", {

    data <- data.frame(logFC=c(1,2,3), y=c(.01,.1,.009))
    clickme_path(system.file("demo", package="clickme"))
    template_id <- "nachocab_scatterplot"
    default_opts <- populate_opts(data, template_id, NULL)
    expect_equal(default_opts$skeleton_path, system.file(.clickme_env$skeleton_file_name, package="clickme"))
    expect_equal(default_opts$template_path, file.path(.clickme_env$path, .clickme_env$templates_dir_name, template_id, .clickme_env$template_file_name))
    expect_equal(default_opts$config_path, file.path(.clickme_env$path, .clickme_env$templates_dir_name, template_id, .clickme_env$config_file_name))
    expect_equal(default_opts$data_path, file.path(.clickme_env$path, .clickme_env$data_dir_name, "data.json"))
    expect_equal(default_opts$viz_path, file.path(.clickme_env$path, "data_nachocab_scatterplot.html"))

})

test_that("loads template_config", {

    data <- data.frame(logFC=c(1,2,3), y=c(.01,.1,.009))
    clickme_path(system.file("demo", package="clickme"))
    default_opts <- populate_opts(data, "nachocab_scatterplot", NULL)

    expect_equal(c("x", "y"), default_opts$template_config$numeric)
    expect_equal("name", default_opts$template_config$character)
})

test_that("custom options", {

    data <- data.frame(logFC=c(1,2,3), y=c(.01,.1,.009))
    clickme_path(system.file("demo", package="clickme"))
    custom_opts <- populate_opts(data, "nachocab_scatterplot", list(data_name = "my_data.json", viz_name = "my_viz.html"))

    expect_equal(custom_opts$data_path, file.path(.clickme_env$path, .clickme_env$data_dir_name, "my_data.json"))
    expect_equal(custom_opts$viz_path, file.path(.clickme_env$path, "my_viz.html"))
})


context("clickme")

test_that("creates visualization", {
    cleanup_files(system.file("", package="clickme"), c(file.path("data", "data.json"), "data_nachocab_scatterplot.html"))

    data <- data.frame(logFC=c(1,2,3), y=c(.01,.1,.009))
    clickme_path(system.file("demo", package="clickme"))
    clickme(data, "nachocab_scatterplot")

    expect_true(system.file(file.path("demo", .clickme_env$data_dir_name, "data.json"), package="clickme"))
    expect_true(system.file(file.path("demo", "data_nachocab_scatterplot.html"), package = "clickme"))
})

# TODO: don't overwrite existing data.json files
# TODO: creates a server
# TODO: embed or link