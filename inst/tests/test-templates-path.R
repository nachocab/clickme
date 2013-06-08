context("set_templates_path")

test_that("clickme paths are set by default", {
    expect_equal(getOption("clickme_templates_path"), system.file("templates", package="clickme"))
    expect_equal(getOption("clickme_output_path"), system.file("templates", package="clickme"))
})

test_that("templates path must be a valid path", {
    options(clickme_templates_path = "fake_path")
    expect_error(clickme(1, "force_directed"), "Path doesn't exist")
})


