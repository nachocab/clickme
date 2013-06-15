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

test_that("numeric data is parsed", {

    # x is a numeric vector, no y => x becomes y, x becomes 1:length(x)
    data <- get_points_data(1:10, NULL, list(point_names = as.character(1:10)))
    expect_equal(data, data.frame(x = 1:10, y = 1:10, point_name = as.character(1:10)))

    # x is a numeric vector, y is a numeric vector
    data <- get_points_data(2:4, 5:7, list(point_names = as.character(1:3)))
    expect_equal(data, data.frame(x = 2:4, y = 5:7, point_name = as.character(1:3)))

    # x is a data frame (x, y, row names)
    data <- data.frame(x = 2:4, y = 5:7, row.names = LETTERS[1:3])
    data <- get_points_data(data, NULL, list(point_names = rownames(data)))
    expect_equivalent(data, data.frame(x = 2:4, y = 5:7, point_name = LETTERS[1:3]))

    # x is a data frame (x, y, row names, extra column)
    data <- data.frame(x = 2:4, y = 5:7, row.names = LETTERS[1:3], extra = 11:13)
    data <- get_points_data(data, NULL, list(point_names = rownames(data)))
    expect_equivalent(data, data.frame(x = 2:4, y = 5:7, point_name = LETTERS[1:3]))

    # x is a matrix (x, y, row names)
    mat <- cbind(2:4,5:7)
    rownames(mat) <- LETTERS[1:3]
    data <- get_points_data(mat, NULL, list(point_names = rownames(mat)))
    expect_equivalent(data, data.frame(x = 2:4, y = 5:7, point_name = LETTERS[1:3]))

    # x is a list (x, y, no names, uneven-size element)
    data <- get_points_data(list(x = 2:4, y = 5:7, extra = 1:10), NULL, list(point_names = as.character(1:3)))
    expect_equivalent(data, data.frame(x = 2:4, y = 5:7, point_name = as.character(1:3)))

})

test_that("x can be categorical", {

    # x is a character vector, no y
    expect_error(get_points_data(c("a", "b", "c"), NULL, list(point_names = as.character(1:3))), "y can't be NULL when x is a character vector")

    # x is a character vector, y is a numeric vector
    data <- get_points_data(c("a", "b", "c"), 2:4, list(point_names = as.character(1:3)))
    expect_equal(data, data.frame(x = c("a","b", "c"), y = 2:4, point_name = as.character(1:3)))

    # x is a data frame (x, y, row names)
    data <- data.frame(x = c("a", "b", "c"), y = 5:7, row.names = LETTERS[1:3])
    data <- get_points_data(data, NULL, list(point_names = rownames(data)))
    expect_equivalent(data, data.frame(x = c("a", "b", "c"), y = 5:7, point_name = LETTERS[1:3]))

    # x is a list (x, y, no names, uneven-size element)
    data <- get_points_data(list(x = c("a", "b", "c"), y = 5:7, extra = 1:10), NULL, list(point_names = as.character(1:3)))
    expect_equivalent(data, data.frame(x = c("a", "b", "c"), y = 5:7, point_name = as.character(1:3)))

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

test_that("extra fields get added", {
params <- list(xlim = c(2,8))
    data <- data.frame(x = c("a", "b", "c"), y = 5:7, row.names = LETTERS[1:3])

    # extra is a data frame
    data <- get_points_data(data, NULL, list(point_names = rownames(data), extra = data.frame(extra1 = c(10,20,30), extra2 = c(100,200,300))))
    expect_equivalent(data, data.frame(x = c("a", "b", "c"), y = 5:7, point_name = LETTERS[1:3], extra1 = c(10,20,30), extra2 = c(100, 200, 300)))

    # extra is a list
    data <- get_points_data(data, NULL, list(point_names = rownames(data), extra = list(extra1 = c(10,20,30), extra2 = c(100,200,300))))
    expect_equivalent(data, data.frame(x = c("a", "b", "c"), y = 5:7, point_name = LETTERS[1:3], extra1 = c(10,20,30), extra2 = c(100, 200, 300)))

    # extra is a matrix
    data <- get_points_data(data, NULL, list(point_names = rownames(data), extra = cbind(extra1=c(10,20,30),extra2=c(100,200,300))))
    expect_equivalent(data, data.frame(x = c("a", "b", "c"), y = 5:7, point_name = LETTERS[1:3], extra1 = c(10,20,30), extra2 = c(100, 200, 300)))
})

test_that("get_tooltip_content_points", {
    data <- data.frame(x = c("a", "b", "c"), y = 5:7, row.names = LETTERS[1:3])
    data <- get_points_data(data, NULL, list(point_names = rownames(data), extra = cbind(extra1=c(10,20,30),extra2=c(100,200,300))))

    tooltip_contents <- get_tooltip_content_points(data)
    expect_equal(tooltip_contents, "<strong>#{d.point_name}</strong><br>y: #{format_property(d.y)}<br>x: #{format_property(d.x)}<br>extra1: #{format_property(d[\"extra1\"])}<br>extra2: #{format_property(d[\"extra2\"])}")
})



