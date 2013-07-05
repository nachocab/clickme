context("Chart-params")

test_chart_path <- file.path(getOption("clickme_templates_path"), "TestChart")
unlink(test_chart_path, recursive = TRUE)
TestChart <- setRefClass('TestChart', contains = "Chart", where=.GlobalEnv)
suppressMessages(new_template("TestChart"))

test_that("padding is valid", {
    params <- list(padding = c(24, 0, 12, 200))
    test_chart <- TestChart$new(params)
    test_chart$get_params()
    expect_equal(test_chart$params$padding, c(top = 24, right = 0, bottom = 12, left = 200))

    params <- list(padding = c(right = 10, bottom = 20, left = 30, top = 40))
    test_chart <- TestChart$new(params)
    test_chart$get_params()
    expect_equal(test_chart$params$padding, c(right = 10, bottom = 20, left = 30,top = 40), info = "changed order")

    params <- list(padding = c(10, 20, 30))
    test_chart <- TestChart$new(params)
    expect_error(test_chart$get_params(), "Please provide four padding values")
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

