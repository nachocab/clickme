context("root_path")

test_that("root path can be set", {
    path <- system.file("examples", package="clickme")
    set_root_path(path)
    expect_equal(path, get_root_path())
})

test_that("root path exists", {
    expect_error(set_root_path("non_existent_path"))
})

test_that("root path contains a ractives folder", {
    path <- file.path(system.file("", package="clickme"), "examples2")
    cleanup_files(path) # to be sure it doesn't exist

    dir.create(path)
    set_root_path(path)
    expect_true(file.exists(system.file(file.path("examples2", .clickme_env$ractives_dir_name), package="clickme")))

    cleanup_files(path)
})

