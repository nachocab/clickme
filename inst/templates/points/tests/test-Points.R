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

test_that("the palette has valid names", {
    params <- list(color_groups = c("a", "a", "b", "c", "b"), palette = c(a = "blue"))
    points <- Points$new(params)
    points$get_params()
    expect_true(all(names(points$params$palette) %in% c("a","b","c")))

    params <- list(color_groups = c("a", "a", "b", "c", "b"), palette = c(a = "blue", b = "pink", c = "green", d = "red", e = "yellow"))
    points <- Points$new(params)
    expect_warning(points$get_params(), "The palette contains color group names that don't appear in color_groups:\n\nd, e")

    params <- list(color_groups = 1:5, palette = c(a = "blue", c = "green", d = "red", e = "yellow"))
    points <- Points$new(params)
    expect_error(points$get_params(), "an unnamed vector")
})

test_that("palette and color_groups", {
    params <- list(data = data.frame(a = 1:5))
    points <- Points$new(params)
    points$get_params()
    expect_equal(points$params$palette, "#000", info = "no color groups, no palette")

    params <- list(data = data.frame(a = 1:5), palette = c("a","b"))
    points <- Points$new(params)
    expect_warning(points$get_params(), "No color_groups provided. Ignoring palette.")
    expect_equal(points$params$palette, "#000", info = "no color groups, palette")

    params <- list(data = data.frame(a = 1:5), color_groups = "a")
    points <- Points$new(params)
    points$get_params()
    expect_equal(points$params$palette, setNames(default_colors(1), c("a")), info = "one color group, no palette")

    params <- list(data = data.frame(a = 1:5), color_groups = c("a", "a", "b", "c", "b"))
    points <- Points$new(params)
    points$get_params()
    expect_equal(points$params$palette, setNames(default_colors(3), c("a", "b", "c")), info = "color groups, no palette")

    params <- list(data = data.frame(a = 1:5), color_groups = c("a", "a", "a", "b", "b"), palette = c("#000", "blue"))
    points <- Points$new(params)
    points$get_params()
    expect_equal(points$params$palette, setNames(params$palette, c("a", "b")), info = "categorical color_groups, unnamed palette")

    params <- list(data = data.frame(a = 1:5), color_groups = c("a", "a", "a", "b", "b"), palette = c(b = "#000", a = "blue"))
    points <- Points$new(params)
    points$get_params()
    expect_equal(points$params$palette, setNames(params$palette, c("b", "a")), info = "categorical color_groups, named palette")

    params <- list(data = data.frame(a = 1:5), color_groups = c(.1,.4,.2,.3,.5))
    points <- Points$new(params)
    points$get_params()
    expect_equal(points$params$palette, c("#278DD6", "#fff", "#d62728"), info = "quantitative color_groups, no palette")

    params <- list(data = data.frame(a = 1:5), color_groups = c(.1,.4,.2,.3,.5), palette = c(a = "#000", b = "blue"))
    points <- Points$new(params)
    expect_error(points$get_params(), "A named palette can only be used with categorical color groups", info = "quantitative color_groups, named palette")

})


context("Points-data")

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

test_that("color_domain is only used with numeric values", {
    params <- list(color_groups = letters[1:10], color_domain = 1:10)
    points <- Points$new(params)
    expect_error(points$get_params(), "color_groups has categorical values")
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
    expect_equal(tooltip_contents, "\"<strong>\" + d.point_name + \"</strong>\" + \"<br>\" + \"y: \" + format_property(d.y) + \"<br>\" + \"x: \" + format_property(d.x) + \"<br>\" + \"extra1: \" + format_property(d[\"extra1\"]) + \"<br>\" + \"extra2: \" + format_property(d[\"extra2\"]) + \"<br>\" + \"group: \" + format_property(d[\"group\"])")
})
