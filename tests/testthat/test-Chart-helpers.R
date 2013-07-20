context("Chart-data")

test_chart_path <- file.path(getOption("clickme_templates_path"), "TestChart")
unlink(test_chart_path, recursive = TRUE)
TestChart <- setRefClass('TestChart', contains = "Chart", where=.GlobalEnv)
suppressMessages(new_template("TestChart"))

test_that("get_urls", {
    params <- list()
    test_chart <- TestChart$new(params)
    test_chart$get_params()
    test_chart$get_file_structure()
    test_chart$get_config()
    test_chart$get_urls()

    expect_equal(test_chart$urls$local, file.path(test_chart$file_structure$paths$output, "temp-TestChart.html"))
    expect_equal(test_chart$urls$server, "http://localhost:8000/temp-TestChart.html")

})

test_that("iframe", {
    params <- list()
    test_chart <- TestChart$new(params)
    test_chart$get_params()
    test_chart$get_file_structure()
    test_chart$get_config()
    test_chart$get_urls()

    iframe <- capture.output(test_chart$iframe()$hide())
    expect_equal(iframe, '<iframe width = "1000" height = "724" src="temp-TestChart.html"> </iframe>')

    iframe <- capture.output(test_chart$iframe(relative_path = "clickme")$hide())
    expect_equal(iframe, '<iframe width = "1000" height = "724" src="clickme/temp-TestChart.html"> </iframe>')
})

test_that("link", {
    params <- list()
    test_chart <- TestChart$new(params)
    test_chart$get_params()
    test_chart$get_file_structure()
    test_chart$get_config()
    test_chart$get_urls()

    link <- capture.output(test_chart$link()$hide())
    expect_equal(link, '<a href="temp-TestChart.html" class="clickme">TestChart</a>')

    link <- capture.output(test_chart$link(class = "oh_my_link")$hide())
    expect_equal(link, '<a href="temp-TestChart.html" class="oh_my_link">TestChart</a>')
})