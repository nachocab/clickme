context("Chart-params")

test_chart_path <- file.path(getOption("clickme_templates_path"), "TestChart")
unlink(test_chart_path, recursive = TRUE)
TestChart <- setRefClass('TestChart', contains = "Chart", where=.GlobalEnv)
suppressMessages(new_template("TestChart"))

test_that("padding is valid", {
    params <- list(padding = c(100, 200, 300, top = 400))
    test_chart <- TestChart$new(params)
    expect_error(test_chart$get_params(), "Wrong padding elements:\n\t 100\n\t 200\n\t 300", info = "any number of unnamed values")

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
    expect_error(test_chart$get_params(), "Wrong padding elements:\n\t 20", info = "wrong names")

})

test_that("action is valid", {
    test_chart <- TestChart$new()
    test_chart$get_params()
    expect_equal(test_chart$params$actions, c("open"))

    test_chart <- TestChart$new(list(actions = "open"))
    test_chart$get_params()
    expect_equal(test_chart$params$actions, c("open"))

    test_chart <- TestChart$new(list(actions = c("open", "link")))
    test_chart$get_params()
    expect_equal(test_chart$params$actions, c("open", "link"))

    test_chart <- TestChart$new(list(actions = c("iframe", "link")))
    test_chart$get_params()
    expect_equal(test_chart$params$actions, c("iframe", "link"))

    test_chart <- TestChart$new(list(actions = c("open", "fake")))
    expect_error(test_chart$get_params(), "Invalid action \"fake\". Please choose one or several among:")
})

unlink(test_chart_path, recursive = TRUE)
