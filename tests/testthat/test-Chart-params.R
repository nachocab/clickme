context("Chart-params")

test_chart_path <- file.path(getOption("clickme_templates_path"), "TestChart")
unlink(test_chart_path, recursive = TRUE)
TestChart <- setRefClass('TestChart', contains = "Chart", where=.GlobalEnv)
suppressMessages(new_template("TestChart"))

test_that("padding is valid", {
    params <- list(padding = c(100, 200, 300, top = 400))
    test_chart <- TestChart$new(params)
    expect_error(test_chart$get_params(), "Wrong padding elements:\n\t100\n\t200\n\t300", info = "any number of unnamed values")

    params <- list(padding = c(right = 100, bottom = 200, left = 300, top = 400))
    test_chart <- TestChart$new(params)
    test_chart$get_params()
    expect_equal(test_chart$params$padding, list(right = 100, bottom = 200, left = 300, top = 400), info = "four named values")

    params <- list(padding = c(right = 100, bottom = 200, top = 400))
    test_chart <- TestChart$new(params)
    test_chart$get_params()
    expect_equal(test_chart$params$padding, list(right = 100, bottom = 200, top = 400, left = 100), info = "less than four named values")

    params <- list(padding = c(botom = 20))
    test_chart <- TestChart$new(params)
    expect_error(test_chart$get_params(), "Wrong padding elements:\n\t20", info = "wrong names")

})

unlink(test_chart_path, recursive = TRUE)

