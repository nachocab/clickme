context("Chart-config")

TestChart <- setRefClass('TestChart', contains = "Chart", where=.GlobalEnv)
test_chart_path <- file.path(getOption("clickme_templates_path"), "TestChart")
suppressMessages(new_template("TestChart"))

test_that("styles and scripts must be valid", {

    test_chart <- TestChart$new()
    test_chart$get_params()
    test_chart$get_file_structure()
    test_chart$get_config()

    test_chart$config$styles <- c("abc.css")
    expect_error(test_chart$validate_config(), "abc.css not found")
    file.create(file.path(test_chart$file_structure$paths$template_assets, "abc.css"))
    expect_that(test_chart$validate_config(), not(throws_error()))

    test_chart$config$scripts <- c("$shared/abc.js")
    expect_error(test_chart$validate_config(), "abc.js not found")
    file.create(file.path(test_chart$file_structure$paths$shared_assets, "abc.js"))
    expect_that(test_chart$validate_config(), not(throws_error()))
    unlink(file.path(test_chart$file_structure$paths$shared_assets, "abc.js"))

    test_chart$config$scripts <- c("http://d3js.org/d3.v3.min.js")
    expect_that(test_chart$validate_config(), not(throws_error()))

})

unlink(test_chart_path, recursive = TRUE)
