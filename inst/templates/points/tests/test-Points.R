context("Points: get_data")

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

test_that("get_tooltip_content_points", {
    params <- list(x = data.frame(x = c("a", "b", "c"), y = 5:7, row.names = LETTERS[1:3]),
                   xlab = "x", ylab = "y",
                   extra = cbind(extra1=c(10,20,30), extra2=c(100,200,300)))
    points <- Points$new(params)
    points$get_data()
    tooltip_contents <- points$get_tooltip_content()
    expect_equal(tooltip_contents, "\"<strong>\" + d.point_name + \"</strong>\" + \"<br>\" + \"y: \" + format_property(d.y) + \"<br>\" + \"x: \" + format_property(d.x) + \"<br>\" + \"extra1: \" + format_property(d[\"extra1\"]) + \"<br>\" + \"extra2: \" + format_property(d[\"extra2\"])")

    params <- list(x = data.frame(x = c("a", "b", "c"), y = 5:7, row.names = LETTERS[1:3]),
                   xlab = "x", ylab = "y",
                   color_groups = c("a","a","b"),
                   extra = cbind(extra1=c(10,20,30), extra2=c(100,200,300)))
    points <- Points$new(params)
    points$get_data()
    tooltip_contents <- points$get_tooltip_content()
    expect_equal(tooltip_contents, "\"<strong>\" + d.point_name + \"</strong>\" + \"<br>\" + \"y: \" + format_property(d.y) + \"<br>\" + \"x: \" + format_property(d.x) + \"<br>\" + \"extra1: \" + format_property(d[\"extra1\"]) + \"<br>\" + \"extra2: \" + format_property(d[\"extra2\"])")
})

test_that("the palette determines the order in which the points are rendered", {
    params <- list(data = 1:5, groups = c(.5,.1,.2,.3,.4), palette = c("blue", "red", "green"))
    points <- Points$new(params)
    points$get_params()
    points$get_data()
    expect_equal(points$data, c(1,5,4,3,2)) # .5 .4 .3 .2 .1 (smallest on top)

    params <- list(data = 1:5, groups = c("c", "a", "b", "c", "b"))
    points <- Points$new(params)
    points$get_params()
    points$get_data()
    expect_equal(points$data, c(1,4,3,5,2)) # c c b b a ("a" on top)

    params <- list(data = 1:5, groups = c("c", "a", "b", "c", "b"), palette = c("blue", "red", "green"))
    points <- Points$new(params)
    points$get_params()
    points$get_data()
    expect_equal(points$data, c(1,4,3,5,2)) # c c b b a ("a" on top)

    params <- list(data = 1:5, groups = c("c", "a", "b", "c", "b"), palette = c(a = "blue", c = "green", b = "red"))
    points <- Points$new(params)
    points$get_data()
    expect_equal(points$data, c(5,3,4,1,2)) # b b c c a ("a" on top)
})


