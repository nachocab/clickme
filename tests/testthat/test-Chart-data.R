context("Chart-data")

test_chart_path <- file.path(getOption("clickme_templates_path"), "TestChart")
unlink(test_chart_path, recursive = TRUE)
TestChart <- setRefClass('TestChart', contains = "Chart", where=.GlobalEnv)
suppressMessages(new_template("TestChart"))

test_that("group_data_rows", {
    params <- list(data = c(1,2,3), group = c("a","b","c"))
    test_chart <- TestChart$new(params)
    test_chart$get_params()
    test_chart$get_data()
    expect_error(test_chart$group_data_rows(params$group), "must be a dataframe")

    params <- list(data = data.frame(x = c(1, 2, 3, 4)), groups = c("a", "c", "b", "a"))
    test_chart <- TestChart$new(params)
    test_chart$get_params()
    test_chart$get_data()
    test_chart$group_data_rows(params$groups)
    expect_equal(test_chart$data$x, c(1, 4, 3, 2))

    params <- list(data = data.frame(x = c(1, 2, 3, 4)), groups = c("a", "c", "b", "a"), order = c("c","b","a"))
    test_chart <- TestChart$new(params)
    test_chart$get_params()
    test_chart$get_data()
    test_chart$group_data_rows(params$groups, params$order)
    expect_equal(test_chart$data$x, c(2, 3, 1, 4))

})

test_that("extra fields get added", {

    # extra can be a data frame, a list or a matrix
    params <- list(data = data.frame(x = c("a", "b", "c")), extra = data.frame(extra1 = c(10,20,30), extra2 = c(100,200,300)))
    test_chart <- TestChart$new(params)
    test_chart$get_data()
    test_chart$add_extra_data_fields()
    expect_equivalent(test_chart$data, data.frame(x = c("a", "b", "c"), extra1 = c(10,20,30), extra2 = c(100, 200, 300)))


})