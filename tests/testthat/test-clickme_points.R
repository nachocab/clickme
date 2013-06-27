context("clickme_points: new")

test_that("main is changed to title", {
    params <- list(main = "paco")
    points <- Points$new(params)

    expect_equal(points$params$title, "paco")
    expect_true(is.null(points$params$main))
})

test_that("color_domain is only used in quantitative scales", {
    params <- list(colorize = letters[1:10], color_domain = 1:10)
    expect_error(Points$new(params), "colorize has categorical values")
})

test_that("the palette has valid names", {
    params <- list(colorize = c("a", "a", "b", "c", "b"), palette = c(a = "blue"))
    points <- Points$new(params)

    expect_true(all(names(points$params$palette) %in% c("a","b","c")))

    params <- list(colorize = c("a", "a", "b", "c", "b"), palette = c(a = "blue", b = "pink", c = "green", d = "red", e = "yellow"))
    expect_warning(Points$new(params), "palette names don't appear in colorize: d, e")

    params <- list(colorize = 1:5, palette = c(a = "blue", c = "green", d = "red", e = "yellow"))
    expect_error(Points$new(params), "an unnamed vector")
})


context("clickme_points: get_data")

test_that("point_names", {
    params <- list(x = 1:10)
    points <- Points$new(params)
    expect_equal(points$data, data.frame(x = 1:10, y = 1:10, point_name = as.character(1:10)))

    params <- list(x = 1:10, point_names = letters[1:10])
    points <- Points$new(params)
    expect_equal(points$data, data.frame(x = 1:10, y = 1:10, point_name = letters[1:10]))
})


test_that("extra fields get added", {

    # extra can be a data frame
    params <- list(x = data.frame(x = c("a", "b", "c"), y = 5:7, row.names = LETTERS[1:3]),
                   extra = data.frame(extra1 = c(10,20,30), extra2 = c(100,200,300)))
    points <- Points$new(params)
    expect_equivalent(points$data, data.frame(x = c("a", "b", "c"), y = 5:7, point_name = LETTERS[1:3], extra1 = c(10,20,30), extra2 = c(100, 200, 300)))

    # extra can be a list
    params <- list(x = data.frame(x = c("a", "b", "c"), y = 5:7, row.names = LETTERS[1:3]),
                   extra = list(extra1 = c(10,20,30), extra2 = c(100,200,300)))
    points <- Points$new(params)
    expect_equivalent(points$data, data.frame(x = c("a", "b", "c"), y = 5:7, point_name = LETTERS[1:3], extra1 = c(10,20,30), extra2 = c(100, 200, 300)))

    # extra can be a matrix
    params <- list(x = data.frame(x = c("a", "b", "c"), y = 5:7, row.names = LETTERS[1:3]),
                   extra = cbind(extra1=c(10,20,30),extra2=c(100,200,300)))
    points <- Points$new(params)
    expect_equivalent(points$data, data.frame(x = c("a", "b", "c"), y = 5:7, point_name = LETTERS[1:3], extra1 = c(10,20,30), extra2 = c(100, 200, 300)))

})

test_that("the palette determines the order in which the points are rendered", {
    params <- list(x = 1:5,
                   colorize = c(.5,.1,.2,.3,.4),
                   palette = c("blue", "red", "green"))
    points <- Points$new(params)
    expect_equal(points$data$x, c(1,5,4,3,2)) # .5 .4 .3 .2 .1 (smallest on top)

    params <- list(x = 1:5,
                   colorize = c("c", "a", "b", "c", "b"))
    points <- Points$new(params)
    expect_equal(points$data$x, c(1,4,3,5,2)) # c c b b a ("a" on top)

    params <- list(x = 1:5,
                   colorize = c("c", "a", "b", "c", "b"),
                   palette = c("blue", "red", "green"))
    points <- Points$new(params)
    expect_equal(points$data$x, c(1,4,3,5,2)) # c c b b a ("a" on top)

    params <- list(x = 1:5,
                   colorize = c("c", "a", "b", "c", "b"),
                   palette = c(a = "blue", c = "green", b = "red"))
    points <- Points$new(params)
    expect_equal(points$data$x, c(5,3,4,1,2)) # b b c c a ("a" on top)
})

test_that("limits reduce the size of the data", {
    params <- list(x = 1:10, y = 1:10, xlim = c(2,8))
    points <- Points$new(params)
    expect_equal(points$data$x, 2:8)

    params$ylim <- c(2,8)
    points <- Points$new(params)
    expect_equal(points$data$y, 2:8)
})

test_that("get_tooltip_content_points", {
    params <- list(x = data.frame(x = c("a", "b", "c"), y = 5:7, row.names = LETTERS[1:3]),
                   xlab = "x", ylab = "y",
                   extra = cbind(extra1=c(10,20,30), extra2=c(100,200,300)))
    points <- Points$new(params)
    tooltip_contents <- points$get_tooltip_content()
    expect_equal(tooltip_contents, "\"<strong>\" + d.point_name + \"</strong>\" + \"<br>\" + \"y: \" + format_property(d.y) + \"<br>\" + \"x: \" + format_property(d.x) + \"<br>\" + \"extra1: \" + format_property(d[\"extra1\"]) + \"<br>\" + \"extra2: \" + format_property(d[\"extra2\"])")

    params <- list(x = data.frame(x = c("a", "b", "c"), y = 5:7, row.names = LETTERS[1:3]),
                   xlab = "x", ylab = "y",
                   colorize = c("a","a","b"),
                   extra = cbind(extra1=c(10,20,30), extra2=c(100,200,300)))
    points <- Points$new(params)
    tooltip_contents <- points$get_tooltip_content()
    expect_equal(tooltip_contents, "\"<strong>\" + d.point_name + \"</strong>\" + \"<br>\" + \"y: \" + format_property(d.y) + \"<br>\" + \"x: \" + format_property(d.x) + \"<br>\" + \"extra1: \" + format_property(d[\"extra1\"]) + \"<br>\" + \"extra2: \" + format_property(d[\"extra2\"])")
})

