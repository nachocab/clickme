context("Chart-params")

TestChart <- setRefClass('TestChart', contains = "Chart", where=.GlobalEnv)
test_chart_path <- file.path(getOption("clickme_templates_path"), "TestChart")
suppressMessages(new_template("TestChart"))

test_that("padding is valid", {
    # default global padding
    test_chart <- TestChart$new(list(padding = c(24, 0, 12, 200)))
    test_chart$get_params()
    expect_equal(test_chart$params$padding, c(top = 24, right = 0, bottom = 12, left = 200))

    # user-provided param padding
    test_chart <- TestChart$new(list(padding = c(10, 20, 30, 40)))
    test_chart$get_params()
    expect_equal(test_chart$params$padding, c(top = 10, right = 20, bottom = 30, left = 40))

    # changed order
    test_chart <- TestChart$new(list(padding = c(right = 10, bottom = 20, left = 30, top = 40)))
    test_chart$get_params()
    expect_equal(test_chart$params$padding, c(right = 10, bottom = 20, left = 30,top = 40))

    # wrong input
    test_chart <- TestChart$new(list(padding = c(10, 20, 30)))
    test_chart$get_unvalidated_params()
    expect_error(test_chart$validate_params(), "Please provide four padding values")
})

test_that("reorder_data_by_colorize", {
    test_chart <- TestChart$new(list(data = data.frame(x = c(1,2,3)),
                                           colorize = c("a","b","c")))
    test_chart$get_params()
    test_chart$get_data()

    reordered_data <- test_chart$reorder_data_by_colorize()
    expect_equal(reordered_data$x, c(3, 2, 1))

    test_chart <- TestChart$new(list(data = data.frame(x = c(1,2,3)),
                                           colorize = c("a","b","c"),
                                           palette = c(a = "blue", c = "red", b = "green")))
    test_chart$get_params()
    test_chart$get_data()

    reordered_data <- test_chart$reorder_data_by_colorize()
    expect_equal(reordered_data$x, c(2, 3, 1))
})

test_that("action is valid", {
    test_chart <- TestChart$new()
    test_chart$get_params()
    expect_equal(test_chart$params$action, c("open"))

    test_chart <- TestChart$new(list(action = "open"))
    test_chart$get_params()
    expect_equal(test_chart$params$action, c("open"))

    test_chart <- TestChart$new(list(action = c("open", "link")))
    test_chart$get_params()
    expect_equal(test_chart$params$action, c("open", "link"))

    test_chart <- TestChart$new(list(action = c("open", "fake")))
    test_chart$get_unvalidated_params()
    expect_error(test_chart$validate_params(), "Invalid action \"fake\". Please choose one or several among:")
})

unlink(test_chart_path, recursive = TRUE)

