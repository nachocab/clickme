context("Points palette")

test_that("categorical ordered_color_group_names", {
    params <- list(data = 1:5, color_groups = factor(c("b", "b", "a", "a", "a"), levels = c("b", "a")))
    points <- Points$new(params)
    points$get_params()
    expect_equal(points$internal$ordered_color_group_names, c("b", "a"), info = "only color_groups, factor")

    params <- list(data = 1:5, color_groups = c("b", "b", "a", "a", "a"))
    points <- Points$new(params)
    points$get_params()
    expect_equal(points$internal$ordered_color_group_names, c("a", "b"), info = "only color_groups, character")

    params <- list(data = 1:5, color_groups = c(5,4,2,3,1))
    points <- Points$new(params)
    points$get_params()
    expect_equal(points$internal$ordered_color_group_names, c(1,2,3,4,5), info = "only color_groups, numeric")

    params <- list(data = 1:5, color_groups = c("b", "b", "a", "a", "a"), palette = c("red", "blue"))
    points <- Points$new(params)
    points$get_params()
    expect_equal(points$internal$ordered_color_group_names, c("a", "b"), info = "color groups, unnamed palette")

    params <- list(data = 1:5, color_groups = c("b", "b", "a", "a", "a"), palette = c(b = "red", a = "blue"))
    points <- Points$new(params)
    points$get_params()
    expect_equal(points$internal$ordered_color_group_names, c("b", "a"), info = "color groups, complete named palette")

    params <- list(data = 1:5, color_groups = c("b", "b", "a", "a", "c"), palette = c(c = "red"))
    points <- Points$new(params)
    points$get_params()
    expect_equal(points$internal$ordered_color_group_names, c("c", "a", "b"), info = "color groups, incomplete named palette")

    params <- list(data = 1:5, color_groups = c("b", "b", "a", "a", "c"), palette = c(c = "red", c = "blue"))
    points <- Points$new(params)
    expect_error(points$get_params(), "Duplicated names in palette:\n\tc", info = "color groups, repeated named palette")

    params <- list(data = 1:5, color_groups = c("b", "b", "a", "a", "a", "c", "d"), palette = c("red", "blue"), color_group_order = c("b", "a", "d", "c"))
    points <- Points$new(params)
    points$get_params()
    expect_equal(points$internal$ordered_color_group_names, c("b", "a", "d", "c"), info = "color groups, unnamed palette, complete color group order")

    params <- list(data = 1:5, color_groups = c("b", "b", "a", "a", "c", "d"), palette = c(b = "red", c = "blue"), color_group_order = c("a", "d"))
    points <- Points$new(params)
    points$get_params()
    expect_equal(points$internal$ordered_color_group_names, c("a", "d", "b", "c"), info = "color groups, incomplete named palette, incomplete color group order")

    params <- list(data = 1:5, color_groups = c("b", "b", "a", "a", "c"), color_group_order = c("c", "c", "b"))
    points <- Points$new(params)
    expect_error(points$get_params(), "Duplicated names in color_group_order:\n\tc", info = "color groups, repeated color_group_order")

})

test_that("quantitative ordered_color_group_names", {

    params <- list(data = data.frame(a = 1:5), color_groups = c(.1,.4,.2,.3,.5), palette = c(a = "#000", b = "blue"))
    points <- Points$new(params)
    expect_error(points$get_params(), "A named palette can only be used with categorical color groups", info = "quantitative color_groups, named palette")

    params <- list(data = data.frame(a = 1:5), color_groups = c(.1,.4,.2,.3,.5), color_group_order = c("a", "b"))
    points <- Points$new(params)
    expect_error(points$get_params(), "color_group_order can only be used with categorical color groups", info = "quantitative color_groups, color_group_order")


})


test_that("validate_palette", {
    params <- list(data = data.frame(a = 1:5))
    points <- Points$new(params)
    points$get_params()
    expect_equal(points$params$palette, "#000", info = "no color groups, no palette")

    params <- list(data = data.frame(a = 1:5), palette = c("a","b"))
    points <- Points$new(params)
    expect_message(points$get_params(), "No color_groups provided. Ignoring palette.")
    expect_equal(points$params$palette, "#000", info = "no color groups, palette")

    params <- list(data = data.frame(a = 1:5), color_groups = "a")
    points <- Points$new(params)
    points$get_params()
    expect_equal(points$params$palette, setNames(default_colors(1), c("a")), info = "one color group, no palette")

    params <- list(data = data.frame(a = 1:5), color_groups = c("a", "a", "a", "b", "b"), palette = c(b = "#000", a = "blue"))
    points <- Points$new(params)
    points$get_params()
    expect_equal(points$params$palette, setNames(params$palette, c("b", "a")), info = "categorical color_groups, named palette")

    params <- list(data = data.frame(a = 1:5), color_groups = c("a", "a", "a", "b", "b"), palette = c(b = "#000"))
    points <- Points$new(params)
    points$get_params()
    expect_equal(points$params$palette, setNames(c("#000", default_colors(1)), c("b", "a")), info = "categorical color_groups, incomplete named palette")

    params <- list(data = data.frame(a = 1:5), color_groups = c(.1,.4,.2,.3,.5))
    points <- Points$new(params)
    points$get_params()
    expect_equal(points$params$palette, c("#278DD6", "#d62728"), info = "quantitative color_groups, no palette")

})
