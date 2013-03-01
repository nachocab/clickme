context("clickme_path")

test_that("sets the default folder structure", {

    cleanup_files(getwd(), .clickme_env$name$templates)
    clickme_path()
    expect_equal(getwd(), .clickme_env$path)
    expect_true(file.exists(file.path(.clickme_env$path, .clickme_env$name$templates)))
    cleanup_files(.clickme_env$path, .clickme_env$name$templates)

    cleanup_files(.clickme_env$name$templates, file.path(getwd(), "tmp"))
    clickme_path(file.path(getwd(), "tmp"))
    expect_equal(file.path(getwd(), "tmp"), .clickme_env$path)
    expect_true(file.exists(file.path(.clickme_env$path, .clickme_env$name$templates)))
    cleanup_files(.clickme_env$path)
})

