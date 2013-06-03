context("set_root_path")

if (!is.null(getOption("clickme_root_path"))) old_clickme_root_path <- getOption("clickme_root_path")

test_that("root path can be preset in .Rprofile", {
    .clickme_env$root_path <- NULL
    options("clickme_root_path" = system.file("tests", package="clickme"))
    expect_equal(getOption("clickme_root_path"), get_root_path())
})

test_that("default root path is used if not present in .Rprofile", {
    .clickme_env$root_path <- NULL
    options("clickme_root_path" = NULL)
    default_path <- system.file("ractives", package="clickme")
    expect_equal(default_path, get_root_path())
})

test_that("root path must be a valid path", {
    expect_error(set_root_path("non_existent_path"), "Path doesn't exist")

    .clickme_env$root_path <- NULL
    options("clickme_root_path" = "fake_path")
    expect_error(get_root_path(), "invalid file path")
})

test_that("root path can be changed", {
    options("clickme_root_path" = system.file("tests", package="clickme"))
    expect_equal(getOption("clickme_root_path"), get_root_path())

    path <- system.file("ractives", package="clickme")
    set_root_path(path)
    expect_equal(path, get_root_path())
})

# To ensure we are not overwriting the current CLICKME_ROOT_PATH in .Rprofile
if (exists("old_clickme_root_path")) options("clickme_root_path" = old_clickme_root_path)

