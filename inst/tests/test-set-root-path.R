context("root_path")

test_that("root path can be set", {
    set_root_path(system.file("demo", package="clickme"))
    expect_equal(system.file("demo", package="clickme"), get_root_path())
})

test_that("root path exists", {
    expect_error(set_root_path("non_existent_path"))
})

test_that("root path contains a templates folder", {
    path <- file.path(system.file("", package="clickme"), "demo2")
    cleanup_files(path) # to be sure it doesn't exist
    dir.create(path)

    set_root_path(path)
    expect_true(file.exists(system.file(file.path("demo2", .clickme_env$templates_dir_name), package="clickme")))

    cleanup_files(path)
})

