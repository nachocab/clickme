context("clickme_points: validate_points_params")

test_that("main is changed to title", {
    params <- list(main = "paco")
    expect_equal(validate_points_params(params)$title, "paco")
    expect_true(is.null(validate_points_params(params)$main))
})

test_that("color_domain is only used in quantitative scales", {
    params <- list(colorize = letters[1:10], color_domain = 1:10)
    expect_error(validate_points_params(params), "colorize has categorical values")
})

test_that("the palette has valid names", {
    params <- list(colorize = c("a", "a", "b", "c", "b"), palette = c(a = "blue"))
    expect_error(validate_points_params(params), "categories don't have a color in palette: b, c")

    params <- list(colorize = c("a", "a", "b", "c", "b"), palette = c(a = "blue", b = "pink", c = "green", d = "red", e = "yellow"))
    expect_error(validate_points_params(params), "palette names don't appear in colorize: d, e")

    params <- list(colorize = 1:5, palette = c(a = "blue", c = "green", d = "red", e = "yellow"))
    expect_error(validate_points_params(params), "an unnamed vector")
})


context("clickme_points: get_points_data")

test_that("point_names", {
    data <- get_points_data(1:10, NULL, list())
    expect_equal(data, data.frame(x = 1:10, y = 1:10, point_name = as.character(1:10)))

    data <- get_points_data(1:10, NULL, list(point_names = letters[1:10]))
    expect_equal(data, data.frame(x = 1:10, y = 1:10, point_name = letters[1:10]))
})

test_that("extra fields get added", {
params <- list(xlim = c(2,8))
    data <- data.frame(x = c("a", "b", "c"), y = 5:7, row.names = LETTERS[1:3])

    # extra is a data frame
    data <- get_points_data(data, NULL, list(point_names = rownames(data), extra = data.frame(extra1 = c(10,20,30), extra2 = c(100,200,300))))
    expect_equivalent(data, data.frame(x = c("a", "b", "c"), y = 5:7, point_name = LETTERS[1:3], extra1 = c(10,20,30), extra2 = c(100, 200, 300)))

    # extra is a list
    data <- get_points_data(data, NULL, list(point_names = LETTERS[1:3], extra = list(extra1 = c(10,20,30), extra2 = c(100,200,300))))
    expect_equivalent(data, data.frame(x = c("a", "b", "c"), y = 5:7, point_name = LETTERS[1:3], extra1 = c(10,20,30), extra2 = c(100, 200, 300)))

    # extra is a matrix
    data <- get_points_data(data, NULL, list(point_names = LETTERS[1:3], extra = cbind(extra1=c(10,20,30),extra2=c(100,200,300))))
    expect_equivalent(data, data.frame(x = c("a", "b", "c"), y = 5:7, point_name = LETTERS[1:3], extra1 = c(10,20,30), extra2 = c(100, 200, 300)))
})

test_that("the palette determines the order in which the points are rendered", {
    params <- list(colorize = c(.5,.1,.2,.3,.4), palette = c("blue", "red", "green"))
    data <- get_points_data(1:5, NULL, params)
    expect_equal(data$x, c(1,5,4,3,2)) # .5 .4 .3 .2 .1 (smallest on top)

    params <- list(colorize = c("c", "a", "b", "c", "b"))
    data <- get_points_data(1:5, NULL, params)
    expect_equal(data$x, c(1,4,3,5,2)) # c c b b a ("a" on top)

    params <- list(colorize = c("c", "a", "b", "c", "b"), palette = c("blue", "red", "green"))
    data <- get_points_data(1:5, NULL, params)
    expect_equal(data$x, c(1,4,3,5,2)) # c c b b a ("a" on top)

    params <- list(colorize = c("c", "a", "b", "c", "b"), palette = c(a = "blue", c = "green", b = "red"))
    data <- get_points_data(1:5, NULL, params)
    expect_equal(data$x, c(5,3,4,1,2)) # b b c c a ("a" on top)
})

test_that("limits reduce the size of the data", {
    params <- list(xlim = c(2,8))
    data <- get_points_data(1:10, 1:10, params)
    expect_equal(data$x, 2:8)
})

test_that("get_tooltip_content_points", {
    data <- data.frame(x = c("a", "b", "c"), y = 5:7, row.names = LETTERS[1:3])
    data <- get_points_data(data, NULL, list(point_names = rownames(data), extra = cbind(extra1=c(10,20,30),extra2=c(100,200,300))))
    params <- list(xlab = "x", ylab = "y")

    tooltip_contents <- get_tooltip_content_points(data, params)
    expect_equal(tooltip_contents, "<strong>#{d.point_name}</strong><br>y: #{format_property(d.y)}<br>x: #{format_property(d.x)}<br>extra1: #{format_property(d[\"extra1\"])}<br>extra2: #{format_property(d[\"extra2\"])}")

    data <- get_points_data(data, NULL, list(point_names = rownames(data), colorize = c("a","a","b"), extra = cbind(extra1=c(10,20,30),extra2=c(100,200,300))))

    tooltip_contents <- get_tooltip_content_points(data, params)
    expect_equal(tooltip_contents, "<strong>#{d.point_name}</strong><br>y: #{format_property(d.y)}<br>x: #{format_property(d.x)}<br>extra1: #{format_property(d[\"extra1\"])}<br>extra2: #{format_property(d[\"extra2\"])}")
})

