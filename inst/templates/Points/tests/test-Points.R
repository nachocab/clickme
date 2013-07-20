context("Points")

test_that("point names", {
    params <- list(x = 1:10)
    points <- Points$new(params)
    points$get_data()
    expect_equal(points$data, data.frame(x = 1:10, y = 1:10, point_name = as.character(1:10)))

    params <- list(x = 1:10, names = letters[1:10])
    points <- Points$new(params)
    points$get_data()
    expect_equal(points$data, data.frame(x = 1:10, y = 1:10, point_name = letters[1:10]))
})

test_that("color_domain", {
    params <- list(color_groups = c(.5,.4,.3,.2,.1))
    points <- Points$new(params)
    points$get_params()
    expect_equal(points$params$color_domain, c(.1, .5), info = "quantitative color_groups, no color_domain")

    params <- list(color_groups = c(.5,.4,.3,.2,.1), color_domain = c(0,1))
    points <- Points$new(params)
    points$get_params()
    expect_equal(points$params$color_domain, c(0, 1), info = "quantitative color_groups, color_domain")

    params <- list(color_groups = letters[1:10], color_domain = c(0,1))
    points <- Points$new(params)
    expect_error(points$get_params(), "color_groups has categorical values", info = "categorical color_groups, color_domain")
})

context("Points data")

test_that("group_data_rows", {

    params <- list(x = 1:5, y = NULL, color_groups = c(.1, .2, .3, .4, .5),  palette = c("#000", "#fff"))
    points <- Points$new(params)
    points$get_params()
    points$get_data()
    expect_equal(points$data$x, c(5, 4, 3, 2, 1), info = "quantitative color_groups, unnamed palette") # .5 .4 .3 .2 .1 (smallest on top)

    params <- list(x = 1:5, y = NULL, color_groups = c("c", "a", "b", "c", "b"))
    points <- Points$new(params)
    points$get_params()
    points$get_data()
    expect_equal(points$data$x, c(4, 1, 5, 3, 2), info = "categorical color_groups, no palette") # c c b b a ("a" on top)

    params <- list(x = 1:5, y = NULL, color_groups = c("c", "a", "b", "c", "b"), palette = c("blue", "red", "green"))
    points <- Points$new(params)
    points$get_params()
    points$get_data()
    expect_equal(points$data$x, c(4, 1, 5, 3, 2), info = "categorical color_groups, unnamed palette") # c c b b a ("a" on top)

    params <- list(x = 1:5, y = NULL, color_groups = c("c", "a", "b", "c", "b"), palette = c(a = "blue", c = "green", b = "red"))
    points <- Points$new(params)
    points$get_params()
    points$get_data()
    expect_equal(points$data$x, c(5, 3, 4, 1 ,2), info = "categorical color_groups, named palette") # b b c c a ("a" on top)
})

test_that("limits reduce the size of the data", {
    params <- list(x = 1:10, y = 1:10, xlim = c(2,8))
    points <- Points$new(params)
    points$get_data()
    expect_equal(points$data$x, 2:8)

    params$ylim <- c(2,8)
    points <- Points$new(params)
    points$get_data()
    expect_equal(points$data$y, 2:8)
})


context("Points clickme")

test_that("clickme", {
    # expect_that(clickme("points", 1:10, action = FALSE), not(throws_error()))
    # capture.output(expect_that(clickme("points", 1:10, action = "iframe"), not(throws_error())))
    capture.output(expect_that(clickme("points", 1:10), not(throws_error())))
})