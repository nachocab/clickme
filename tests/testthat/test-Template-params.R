context("Template-params")

TestTemplate <- setRefClass('TestTemplate', contains = "Template", where=.GlobalEnv)
test_template_path <- file.path(getOption("clickme_templates_path"), "testtemplate")
dir.create(test_template_path)
file.create(file.path(test_template_path, "template.Rmd"))
file.create(file.path(test_template_path, "config.yml"))
file.create(file.path(test_template_path, "translator.R")) # Todo: remove this requirement

test_that("validate_padding", {
    # default global padding
    test_template <- TestTemplate$new(list(padding = c(24, 0, 12, 200)))
    test_template$get_params()
    expect_equal(test_template$params$padding, c(top = 24, right = 0, bottom = 12, left = 200))

    # user-provided param padding
    test_template <- TestTemplate$new(list(padding = c(10, 20, 30, 40)))
    test_template$get_params()
    expect_equal(test_template$params$padding, c(top = 10, right = 20, bottom = 30, left = 40))

    # changed order
    test_template <- TestTemplate$new(list(padding = c(right = 10, bottom = 20, left = 30, top = 40)))
    test_template$get_params()
    expect_equal(test_template$params$padding, c(right = 10, bottom = 20, left = 30,top = 40))

    # wrong input
    test_template <- TestTemplate$new(list(padding = c(10, 20, 30)))
    expect_error(test_template$get_params(), "Please provide four padding values")
})

test_that("reorder_data_by_colorize", {
    test_template <- TestTemplate$new(list(data = data.frame(x = c(1,2,3)),
                                           colorize = c("a","b","c")))
    test_template$get_params()
    test_template$get_data()

    reordered_data <- test_template$reorder_data_by_colorize()
    expect_equal(reordered_data$x, c(3, 2, 1))

    # params <- list(colorize = c("a","b","c"), palette = c(a = "blue", c = "red", b = "green"))
    # reordered_data <- reorder_data_by_colorize(data, params)
    # expect_equal(reordered_data$x, c(2, 3, 1))
})

test_that("reorder_data_by_colorize", {
    # data <- data.frame(x=c(1,2,3))
    # params <- list(colorize = c("a","b","c"))
    # reordered_data <- reorder_data_by_colorize(data, params)
    # expect_equal(reordered_data$x, c(3, 2, 1))

    # params <- list(colorize = c("a","b","c"), palette = c(a = "blue", c = "red", b = "green"))
    # reordered_data <- reorder_data_by_colorize(data, params)
    # expect_equal(reordered_data$x, c(2, 3, 1))
})

unlink(test_template_path, recursive = TRUE)

