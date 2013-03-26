context("set_root_path")

if (exists("CLICKME_ROOT_PATH")) old_clickme_root_path <- CLICKME_ROOT_PATH

test_that("root path can be preset in .Rprofile", {
    .clickme_env$root_path <- NULL
    CLICKME_ROOT_PATH <<- system.file("tests", package="clickme")
    expect_equal(CLICKME_ROOT_PATH, get_root_path())
})

test_that("default root path is used if not present in .Rprofile", {
    .clickme_env$root_path <- NULL
    CLICKME_ROOT_PATH <<- NULL
    default_path <- system.file("examples", package="clickme")
    expect_equal(default_path, get_root_path())
})

test_that("root path must be a valid path", {
    expect_error(set_root_path("non_existent_path"), "Path doesn't exist")

    .clickme_env$root_path <- NULL
    CLICKME_ROOT_PATH <<- "fake_path"
    expect_error(get_root_path(), "invalid file path")
})

test_that("root path can be changed", {
    CLICKME_ROOT_PATH <<- system.file("tests", package="clickme")
    expect_equal(CLICKME_ROOT_PATH, get_root_path())

    path <- system.file("examples", package="clickme")
    set_root_path(path)
    expect_equal(path, get_root_path())
})

# To ensure we are not overwriting the current CLICKME_ROOT_PATH in .Rprofile
if (exists("old_clickme_root_path")) CLICKME_ROOT_PATH <<- old_clickme_root_path

