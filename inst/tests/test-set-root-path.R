context("set_root_path")

test_that("root path can be changed", {
    path <- system.file("", package="clickme")
    set_root_path(path)
    expect_equal(path, get_root_path())
})

test_that("root path exists", {
    expect_error(set_root_path("non_existent_path"), "Path doesn't exist")
})

