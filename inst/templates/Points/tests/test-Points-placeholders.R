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
    expect_equal(no_whitespace(points$get_d3_color_scale()), "d3.scale.linear().domain([-2,0,2]).range([\"#278DD6\",\"white\",\"#d62728\"]).interpolate(d3.interpolateLab);", info = "quantitative, color_groups")

    params <- list(color_groups = c("a", "a", "b", "c", "b"))
    points <- Points$new(params)
    points$get_params()
    expect_equal(no_whitespace(points$get_d3_color_scale()), gettextf("d3.scale.ordinal().range([\"%s\",\"%s\",\"%s\"]);", default_colors(3)[1], default_colors(3)[2], default_colors(3)[3]), info = "categorical, color_groups")
})

test_that("get_tooltip_content", {
    params <- list(x = data.frame(x = c("a", "b", "c"), y = c(5.5,6,6.7), row.names = LETTERS[1:3]),
                   ylab = "This is the y axis",
                   extra = cbind(extra1=c(10,20,30), extra2=c(100,200.3,300)))
    points <- Points$new(params)
    points$get_params()
    points$get_data()
    tooltip_contents <- points$get_tooltip_content()

    expect_equal(no_whitespace(tooltip_contents), no_whitespace("
 \"<table>
    <tr>
        <td colspan='2' class='tooltip-title'>\" + d.point_name + \"</td>
    </tr>
    <tr class='tooltip-metric'>
        <td class='tooltip-metric-name'>x</td><td class='tooltip-metric-value'>\" + d['x'] + \"</td>
    </tr>
    <tr class='tooltip-metric'>
        <td class='tooltip-metric-name'>This is the y axis</td>
        <td class='tooltip-metric-value'>\" + d3.format('.2f')(d['y']) + \"</td>
    </tr>
    <tr class='tooltip-metric'>
        <td class='tooltip-metric-name'>extra1</td>
        <td class='tooltip-metric-value'>\" + d['extra1'] + \"</td>
    </tr>
    <tr class='tooltip-metric'>
        <td class='tooltip-metric-name'>extra2</td>
        <td class='tooltip-metric-value'>\" + d3.format('.2f')(d['extra2']) + \"</td>
    </tr>
</table>\""), info = "ylab, extra")

    params <- list(x = data.frame(x = c("a", "b", "c"), y = c(5.5,6,6.7), row.names = LETTERS[1:3]),
                   ylab = "This is the y axis",
                   extra = cbind(extra1=c(10,20,30), extra2=c(100,200.3,300)),
                   formats = list(y = "s", extra1 = ".2f", extra2 = ".3f"))
    points <- Points$new(params)
    points$get_params()
    points$get_data()
    tooltip_contents <- points$get_tooltip_content()

    expect_equal(no_whitespace(tooltip_contents), no_whitespace("
 \"<table>
    <tr>
        <td colspan='2' class='tooltip-title'>\" + d.point_name + \"</td>
    </tr>
    <tr class='tooltip-metric'>
        <td class='tooltip-metric-name'>x</td><td class='tooltip-metric-value'>\" + d['x'] + \"</td>
    </tr>
    <tr class='tooltip-metric'>
        <td class='tooltip-metric-name'>This is the y axis</td>
        <td class='tooltip-metric-value'>\" + d['y'] + \"</td>
    </tr>
    <tr class='tooltip-metric'>
        <td class='tooltip-metric-name'>extra1</td>
        <td class='tooltip-metric-value'>\" + d3.format('.2f')(d['extra1']) + \"</td>
    </tr>
    <tr class='tooltip-metric'>
        <td class='tooltip-metric-name'>extra2</td>
        <td class='tooltip-metric-value'>\" + d3.format('.3f')(d['extra2']) + \"</td>
    </tr>
</table>\""), info = "ylab, extra, formats")

    params <- list(x = data.frame(x = c("a", "b", "c"), y = c(5.5,6,6.7), row.names = LETTERS[1:3]),
                   ylab = "This is the y axis",
                   extra = cbind(extra1=c(10,20,30), extra2=c(100,200.3,300)),
                   color_groups = c("A","A","B"), color_title = "My groups")
    points <- Points$new(params)
    points$get_params()
    points$get_data()
    tooltip_contents <- points$get_tooltip_content()

    expect_equal(no_whitespace(tooltip_contents), no_whitespace("
 \"<table>
    <tr>
        <td colspan='2' class='tooltip-title'>\" + d.point_name + \"</td>
    </tr>
    <tr class='tooltip-metric'>
        <td class='tooltip-metric-name'>x</td><td class='tooltip-metric-value'>\" + d['x'] + \"</td>
    </tr>
    <tr class='tooltip-metric'>
        <td class='tooltip-metric-name'>This is the y axis</td>
        <td class='tooltip-metric-value'>\" + d3.format('.2f')(d['y']) + \"</td>
    </tr>
    <tr class='tooltip-metric'>
        <td class='tooltip-metric-name'>extra1</td>
        <td class='tooltip-metric-value'>\" + d['extra1'] + \"</td>
    </tr>
    <tr class='tooltip-metric'>
        <td class='tooltip-metric-name'>extra2</td>
        <td class='tooltip-metric-value'>\" + d3.format('.2f')(d['extra2']) + \"</td>
    </tr>
    <tr class='tooltip-metric'>
        <td class='tooltip-metric-name'>My groups</td>
        <td class='tooltip-metric-value'>\" + d['color_group'] + \"</td>
    </tr>
</table>\""), info = "ylab, extra, color_groups, color_title")

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
