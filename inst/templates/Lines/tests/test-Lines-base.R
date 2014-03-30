context("Lines base")

test_that("lines have names", {
    params <- list(x = c(2, 3, 4), names = "my_line")
    lines <- Lines$new(params)
    lines$get_params()
    lines$get_data()
    expect_equal(get_attrs(lines$data, c("x", "y", "line_name")),
        list(
            list(
                list(x = 1, y = 2, line_name = "my_line"),
                list(x = 2, y = 3, line_name = "my_line"),
                list(x = 3, y = 4, line_name = "my_line")
            )
        ),
        info = "one line")

    params <- list(x = data.frame.by.rows(c(2, 3, 4),
                                          c(3, 4, 5)),
                   y = NULL,
                   names = c("A", "B"))
        lines <- Lines$new(params)
        lines$get_params()
        lines$get_data()
        expect_equal(get_attrs(lines$data, c("x", "y", "line_name")),
            list(
                list(
                    list(x = 1, y = 2, line_name = "A"),
                    list(x = 2, y = 3, line_name = "A"),
                    list(x = 3, y = 4, line_name = "A")
                ),
                list(
                    list(x = 1, y = 3, line_name = "B"),
                    list(x = 2, y = 4, line_name = "B"),
                    list(x = 3, y = 5, line_name = "B")
                )
            ),
            info = "multiple lines")

    params <- list(x = data.frame.by.rows(c(2, 3),
                                          c(3, 4),
                                          c(4, 5),
                                          c(5, 6),
                                          c(6, 7)),
                   y = NULL,
                   names = c("z", "a", "e", "b", "c"))
    lines <- Lines$new(params)
    lines$get_params()
    lines$get_data()
    expect_equal(sapply(lines$data, function(line) line[[1]]$line_name),
                 c("z", "a", "e", "b", "c"),
                 info = "names, order is preserved")

#     params <- list(x = data.frame.by.rows(c(2, 3),
#                                           c(3, 4),
#                                           row.names = c("A", "B")),
#                    y = NULL)
#     lines <- Lines$new(params)
#     lines$get_params()
#     lines$get_data()
#     expect_equal(sapply(lines$data, function(line) line[[1]]$line_name),
#                  c("A", "B"),
#                  info = "names are implied")
})

test_that("validate_tooltip_formats", {
    params <- list(x = 1:10,
                   extra = list(a = 1),
                   tooltip_formats = list(paco = "d"))
    lines <- Lines$new(params)
    lines$get_params()
    expect_error(lines$get_data(), "The following format names are not x, y, or any of the extra names:\n\tpaco")
})

test_that("color_domain", {
    params <- list(color_groups = c(.5,.4,.3,.2,.1))
    lines <- Lines$new(params)
    lines$get_params()
    expect_equal(lines$params$color_domain, c(.1, .5), info = "quantitative color_groups, no color_domain")

    params <- list(color_groups = c(.5,.4,.3,.2,.1), color_domain = c(0,1))
    lines <- Lines$new(params)
    lines$get_params()
    expect_equal(lines$params$color_domain, c(0, 1), info = "quantitative color_groups, color_domain")

    params <- list(color_groups = letters[1:10], color_domain = c(0,1))
    lines <- Lines$new(params)
    expect_error(lines$get_params(), "color_groups has categorical values", info = "categorical color_groups, color_domain")
})

context("Lines clickme")

# sanity test
test_that("clickme", {
    capture.output(expect_that(clickme("lines", 1:10), not(throws_error())))
})