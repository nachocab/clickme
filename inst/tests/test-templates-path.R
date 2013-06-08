context("set_templates_path")

if (!is.null(getOption("clickme_templates_path"))) old_clickme_templates_path <- getOption("clickme_templates_path")

test_that("templates path can be preset in .Rprofile", {
    .clickme_env$templates_path <- NULL
    options("clickme_templates_path" = system.file("tests", package="clickme"))
    expect_equal(getOption("clickme_templates_path"), get_templates_path())
})

test_that("default templates path is used if not present in .Rprofile", {
    .clickme_env$templates_path <- NULL
    options("clickme_templates_path" = NULL)
    default_path <- system.file("ractives", package="clickme")
    expect_equal(default_path, get_templates_path())
})

test_that("templates path must be a valid path", {
    expect_error(set_templates_path("non_existent_path"), "Path doesn't exist")

    .clickme_env$templates_path <- NULL
    options("clickme_templates_path" = "fake_path")
    expect_error(get_templates_path(), "invalid file path")
})

test_that("templates path can be changed", {
    options("clickme_templates_path" = system.file("tests", package="clickme"))
    expect_equal(getOption("clickme_templates_path"), get_templates_path())

    path <- system.file("ractives", package="clickme")
    set_templates_path(path)
    expect_equal(path, get_templates_path())
})

# To ensure we are not overwriting the current CLICKME_templates_path in .Rprofile
if (exists("old_clickme_templates_path")) options("clickme_templates_path" = old_clickme_templates_path)

