context("Lines unify_format")

test_that("line and point extras get added", {
    params <- list(x = list(c(1, 2, 3),
                            c(4, 5)),
                   y = list(c(2, 3, 4),
                            c(6, 7)),
                   width = c(6, 10),
                   extra = list(extra1 = c(10, 20),
                                extra2 = c(100, 200))
                   )
    lines <- Lines$new(params)
    lines$get_params()
    data <- lines$unify_format()

    expect_equal(get_attrs(data, c("x", "y", "extra1", "extra2", "line_stroke_width", "radius", "line_name")),
                 list(
                     list(
                         list(x = 1, y = 2, extra1 = 10, extra2 = 100, line_stroke_width = 6, radius = 5, line_name = "1"),
                         list(x = 2, y = 3, extra1 = 10, extra2 = 100, line_stroke_width = 6, radius = 5, line_name = "1"),
                         list(x = 3, y = 4, extra1 = 10, extra2 = 100, line_stroke_width = 6, radius = 5, line_name = "1")
                     ),
                     list(
                         list(x = 4, y = 6, extra1 = 20, extra2 = 200, line_stroke_width = 10, radius = 5, line_name = "2"),
                         list(x = 5, y = 7, extra1 = 20, extra2 = 200, line_stroke_width = 10, radius = 5, line_name = "2")
                     )
                 ))
})