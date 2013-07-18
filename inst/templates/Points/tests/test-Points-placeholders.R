context("Points placeholders")

test_that("get_color_legend_counts", {
    params <- list(color_groups = c(rep("a", 5), rep("b", 3), rep("c", 2)))
    points <- Points$new(params)
    points$get_params()
    expect_equivalent(points$get_color_legend_counts(), as.table(c(a = 5, b = 3, c = 2)))
})

test_that("get_d3_color_scale", {
    points <- Points$new()
    points$get_params()
    expect_equal(no_whitespace(points$get_d3_color_scale()), "d3.scale.ordinal().range([\"#000\"]);", info = "no color_groups")

    params <- list(color_groups = c(1:5))
    points <- Points$new(params)
    points$get_params()
    expect_equal(no_whitespace(points$get_d3_color_scale()), "d3.scale.linear().domain([1,5]).range([\"#278DD6\",\"#d62728\"]).interpolate(d3.interpolateLab);", info = "quantitative, color_groups")

    params <- list(color_groups = c(-2:2))
    points <- Points$new(params)
    points$get_params()
    expect_equal(no_whitespace(points$get_d3_color_scale()), "d3.scale.linear().domain([-2,0,2]).range([\"#278DD6\",\"#fff\",\"#d62728\"]).interpolate(d3.interpolateLab);", info = "quantitative, color_groups")

    params <- list(color_groups = c("a", "a", "b", "c", "b"))
    points <- Points$new(params)
    points$get_params()
    expect_equal(no_whitespace(points$get_d3_color_scale()), "d3.scale.ordinal().range([\"#24A5F9\",\"#d62728\",\"#ff7f0e\"]);", info = "categorical, color_groups")
})


test_that("get_tooltip_content", {
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


test_that("get_categorical_domains", {
    params <- list(x = 1:10)
    points <- Points$new(params)
    points$get_data()
    expect_equal(no_whitespace(points$get_categorical_domains()), "{x:null,y:null}")

    params <- list(x = letters[1:10], y = 1:10)
    points <- Points$new(params)
    points$get_data()
    expect_equal(no_whitespace(points$get_categorical_domains()), "{x:[\"a\",\"b\",\"c\",\"d\",\"e\",\"f\",\"g\",\"h\",\"i\",\"j\"],y:null}")
})

test_that("get_data_ranges", {
    params <- list(x = 1:10)
    points <- Points$new(params)
    points$get_data()
    expect_equal(no_whitespace(points$get_data_ranges()), "{x:[1,10],y:[1,10]}", info = "numeric x")

    params <- list(x = factor(1:10, levels = 10:1), y = 1:10)
    points <- Points$new(params)
    points$get_data()
    expect_equal(no_whitespace(points$get_data_ranges()), "{x:[\"10\",\"9\",\"8\",\"7\",\"6\",\"5\",\"4\",\"3\",\"2\",\"1\"],y:[1,10]}")

    params <- list(x = letters[1:10], y = 1:10)
    points <- Points$new(params)
    points$get_data()
    expect_equal(no_whitespace(points$get_data_ranges()), "{x:[\"a\",\"b\",\"c\",\"d\",\"e\",\"f\",\"g\",\"h\",\"i\",\"j\"],y:[1,10]}")
})
