context("root_path")

test_that("sets root_path", {
    set_root_path(system.file("demo", package="clickme"))
    expect_equal(system.file("demo", package="clickme"), .clickme_env$root_path)
    expect_error(set_root_path("fake_path")))
})

