context("clickme")

test_that("clickme sets current template", {
    expect_error(clickme("test_chart"), "template is not installed in path")

    new_template("test_chart")
    clickme("test_chart")
    expect_equal(getOption("clickme_current_template"), "test_chart")
})
unlink(file.path(getOption("clickme_templates_path"), "TestChart"), recursive = TRUE)
