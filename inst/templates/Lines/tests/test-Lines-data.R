context("Lines data")

test_that("get_data works with one line", {
    params <- list(x = c(2, 3, 4),
                   y = NULL)
    lines <- Lines$new(params)
    lines$get_params()
    lines$get_data()
    expect_equal(lines$data,
        list(
            list(
                list(x = 1, y = 2, line_name = "1"),
                list(x = 2, y = 3, line_name = "1"),
                list(x = 3, y = 4, line_name = "1")
            )
        ),
        info = "x is a numeric vector, y is NULL")

    params <- list(x = c(2, 3, 4),
                   y = c(5, 6, 7))
    lines <- Lines$new(params)
    lines$get_params()
    lines$get_data()
    expect_equal(lines$data,
        list(
            list(
                list(x = 2, y = 5, line_name = "1"),
                list(x = 3, y = 6, line_name = "1"),
                list(x = 4, y = 7, line_name = "1")
            )
        ),
        info = "x is a numeric vector, y is a numeric vector")

    params <- list(x = data.frame(x1 = c(2, 3, 4),
                                  y1 = c(5, 6, 7)),
                   y = NULL)
    lines <- Lines$new(params)
    lines$get_params()
    lines$get_data()
    expect_equal(lines$data,
        list(
            list(
                list(x = 2, y = 5, line_name = "1"),
                list(x = 3, y = 6, line_name = "1"),
                list(x = 4, y = 7, line_name = "1")
            )
        ),
        info = "x is a two-column dataframe, y is NULL")
})

test_that("get_data works with multiple lines", {
    params <- list(x = data.frame(
                        x1 = c(2, 3, 4),
                        y1 = c(5, 6, 7),
                        x2 = c(0, 1, 2),
                        y2 = c(7, 8, 9)
                   ),
                   y = NULL)
    lines <- Lines$new(params)
    lines$get_params()
    lines$get_data()
    expect_equal(lines$data,
        list(
            list(
                list(x = 2, y = 5, line_name = "1"),
                list(x = 3, y = 6, line_name = "1"),
                list(x = 4, y = 7, line_name = "1")
            ),
            list(
                list(x = 0, y = 7, line_name = "2"),
                list(x = 1, y = 8, line_name = "2"),
                list(x = 2, y = 9, line_name = "2")
            )
        ),
        info = "x is a data.frame with an even number of columns, y is NULL")

    params <- list(x = data.frame(
                        x1 = c(2, 3, 4),
                        y1 = c(5, 6, 7),
                        x2 = c(0, 1, 2),
                        y2 = c(7, 8, 9),
                        x3 = c(1, 2, 3)
                   ),
                   y = NULL)
    lines <- Lines$new(params)
    lines$get_params()
    expect_warning(lines$get_data(), "data doesn't have an even number of columns. Skipping column 5")
    expect_equal(lines$data,
        list(
            list(
                list(x = 2, y = 5, line_name = "1"),
                list(x = 3, y = 6, line_name = "1"),
                list(x = 4, y = 7, line_name = "1")
            ),
            list(
                list(x = 0, y = 7, line_name = "2"),
                list(x = 1, y = 8, line_name = "2"),
                list(x = 2, y = 9, line_name = "2")
            )
        ),
        info = "x is a data.frame with an odd number of columns, y is NULL")

    params <- list(x = data.frame(
                        x1 = c(2, 3, 4),
                        x2 = c(0, 1, 2)
                   ),
                   y = data.frame(
                        y1 = c(5, 6, 7),
                        y2 = c(7, 8, 9)
                   ))
    lines <- Lines$new(params)
    lines$get_params()
    lines$get_data()
    expect_equal(lines$data,
        list(
            list(
                list(x = 2, y = 5, line_name = "1"),
                list(x = 3, y = 6, line_name = "1"),
                list(x = 4, y = 7, line_name = "1")
            ),
            list(
                list(x = 0, y = 7, line_name = "2"),
                list(x = 1, y = 8, line_name = "2"),
                list(x = 2, y = 9, line_name = "2")
            )
        ),
        info = "x and y are data.frames with the same number of columns")

    params <- list(x = data.frame(
                        x1 = c(2, 3, 4),
                        x2 = c(0, 1, 2)
                   ),
                   y = data.frame(
                        y1 = c(5, 6, 7, 5),
                        y2 = c(7, 8, 9, 5)
                   ))
    lines <- Lines$new(params)
    lines$get_params()
    expect_error(lines$get_data(), "x and y have different number of columns: 3 vs. 4")

    params <- list(x = c(1,2,3),
                   y = data.frame(
                        y1 = c(5, 6, 7),
                        y2 = c(7, 8, 9)
                   ))
    lines <- Lines$new(params)
    lines$get_params()
    expect_error(lines$get_data(), "If y is a dataframe, x must also be a dataframe, but it's a")

})

# test_that("cluster_data_rows", {

#     params <- list(x = c(1, 2, 3, 4, 5), y = NULL, color_groups = c(.1, .2, .3, .4, .5),  palette = c("#000", "#fff"))
#     lines <- Lines$new(params)
#     lines$get_params()
#     lines$get_data()
#     expect_equal(lines$data$x, c(5, 4, 3, 2, 1), info = "quantitative color_groups, unnamed palette") # .5 .4 .3 .2 .1 (smallest on top)

#     params <- list(x = c(1, 2, 3, 4, 5), y = NULL, color_groups = c("c", "a", "b", "c", "b"))
#     lines <- Lines$new(params)
#     lines$get_params()
#     lines$get_data()
#     expect_equal(lines$data$x, c(4, 1, 5, 3, 2), info = "categorical color_groups, no palette") # c c b b a ("a" on top)

#     params <- list(x = c(1, 2, 3, 4, 5), y = NULL, color_groups = c("c", "a", "b", "c", "b"), palette = c("blue", "red", "green"))
#     lines <- Lines$new(params)
#     lines$get_params()
#     lines$get_data()
#     expect_equal(lines$data$x, c(4, 1, 5, 3, 2), info = "categorical color_groups, unnamed palette") # c c b b a ("a" on top)

#     params <- list(x = c(1, 2, 3, 4, 5), y = NULL, color_groups = c("c", "a", "b", "c", "b"), palette = c(a = "blue", c = "green", b = "red"))
#     lines <- Lines$new(params)
#     lines$get_params()
#     lines$get_data()
#     expect_equal(lines$data$x, c(5, 3, 4, 1 ,2), info = "categorical color_groups, named palette") # b b c c a ("a" on top)

# })

# test_that("extra fields get added", {
#     # extra can be a data frame, a list or a matrix
#     params <- list(x = c("a", "b", "c"), y = 1:3, extra = data.frame(extra1 = c(10,20,30), extra2 = c(100,200,300)))
#     lines <- Lines$new(params)
#     lines$get_params()
#     lines$get_data()
#     expect_equivalent(lines$data, data.frame(x = c("a", "b", "c"), y = 1:3, line_name = as.character(1:3), radius = 5, extra1 = c(10,20,30), extra2 = c(100, 200, 300)))

#     params <- list(x = c("a", "b", "c", "d"), y = c(1:3, NA), extra = data.frame(extra1 = c(10,20,30,40), extra2 = c(100,200,300,400)))
#     lines <- Lines$new(params)
#     lines$get_params()
#     lines$get_data()
#     expect_equivalent(lines$data, data.frame(x = c("a", "b", "c"), y = 1:3, line_name = as.character(1:3), radius = 5, extra1 = c(10,20,30), extra2 = c(100, 200, 300)))
# })

# test_that("limits reduce the size of the data", {
#     params <- list(x = 1:10, y = 1:10, xlim = c(2,8))
#     lines <- Lines$new(params)
#     lines$get_data()
#     expect_equal(lines$data$x, 2:8)

#     params$ylim <- c(2,8)
#     lines <- Lines$new(params)
#     lines$get_data()
#     expect_equal(lines$data$y, 2:8)
# })
