context("Lines placeholders")

test_that("get_color_legend_counts", {
    params <- list(color_groups = c(rep("a", 5), rep("b", 3), rep("c", 2)))
    lines <- Lines$new(params)
    lines$get_params()
    expect_equivalent(lines$get_color_legend_counts(), as.table(c(a = 5, b = 3, c = 2)))
})

test_that("get_d3_color_scale", {
    params <- list(x = 1:5)
    lines <- Lines$new(params)
    lines$get_params()
    lines$get_data()
    expect_equal(no_whitespace(lines$get_d3_color_scale()), "d3.scale.ordinal().range([\"#000\"]);", info = "no color_groups")

    params <- list(color_groups = c(1:5))
    lines <- Lines$new(params)
    lines$get_params()
    expect_equal(no_whitespace(lines$get_d3_color_scale()), "d3.scale.linear().domain([1,5]).range([\"#278DD6\",\"#d62728\"]).interpolate(d3.interpolateLab);", info = "quantitative, color_groups")

    params <- list(color_groups = c(-2:2))
    lines <- Lines$new(params)
    lines$get_params()
    expect_equal(no_whitespace(lines$get_d3_color_scale()), "d3.scale.linear().domain([-2,0,2]).range([\"#278DD6\",\"white\",\"#d62728\"]).interpolate(d3.interpolateLab);", info = "quantitative, color_groups")

    params <- list(x = as.data.frame(rbind(c(2, 3),
                                           c(3, 4),
                                           c(4, 5),
                                           c(5, 6),
                                           c(6, 7))),
                   color_groups = c("a", "a", "a", "b", "b"),
                   palette = c(b = "black", c = "red", a = "blue"))
    lines <- Lines$new(params)
    lines$get_params()
    lines$get_data()
    expect_equal(no_whitespace(lines$get_d3_color_scale()), sprintf("d3.scale.ordinal().range([\"%s\",\"%s\"]);", "blue", "black"), info = "categorical, color_groups")
})

test_that("get_tooltip_content", {
    params <- list(x = c("a", "b", "c"),
                   y = c(5.5,6,6.7),
                   ylab = "This is the y axis",
                   extra = list(extra1=10,
                                extra2=100.1))
    lines <- Lines$new(params)
    lines$get_params()
    lines$get_data()
    tooltip_contents <- lines$get_tooltip_content()

    expect_equal(no_whitespace(tooltip_contents), no_whitespace("
        function(d){
            return \"<table>
                <tr>
                    <td colspan='2' class='tooltip-title'>\" + d.line_name + \"</td>
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
            </table>\"
        };
    "), info = "ylab, extra")

    params <- list(x = c("a", "b", "c"),
                   y = c(5.5,6,6.7),
                   ylab = "This is the y axis",
                   extra = list(extra1=10,
                                extra2=100.2),
                   tooltip_formats = list(y = "s",
                                          extra1 = ".2f",
                                          extra2 = ".3f"))
    lines <- Lines$new(params)
    lines$get_params()
    lines$get_data()
    tooltip_contents <- lines$get_tooltip_content()

    expect_equal(no_whitespace(tooltip_contents), no_whitespace("
        function(d){
            return \"<table>
                <tr>
                    <td colspan='2' class='tooltip-title'>\" + d.line_name + \"</td>
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
            </table>\"
        };
    "), info = "ylab, extra, tooltip_formats")

    params <- list(x = c("a", "b", "c"),
                   y = c(5.5, 6, 6.7),
                   ylab = "This is the y axis",
                   extra = list(extra1=10,
                                extra2=100.2),
                   color_groups = c("A","A","B"),
                   color_title = "My groups")
    lines <- Lines$new(params)
    lines$get_params()
    expect_error(lines$get_data(), "Number of lines is 1, but the following parameters have more values than lines: \n\tcolor_group")

    params <- list(x = c("a", "b", "c"),
                   y = as.data.frame(rbind(c(5.5, 4, 3),
                                           c(6, 2, 1.3),
                                           c(6.7, 1, 6.2)
                                           )),
                   ylab = "This is the y axis",
                   extra = list(extra1 = c(10,20,30),
                                extra2 = c(100.1,200,300)),
                   color_groups = c("A","A","B"),
                   color_title = "My groups")
    lines <- Lines$new(params)
    lines$get_params()
    lines$get_data()
    tooltip_contents <- lines$get_tooltip_content()

    expect_equal(no_whitespace(tooltip_contents), no_whitespace("
        function(d){
            return \"<table>
                <tr>
                    <td colspan='2' class='tooltip-title'>\" + d.line_name + \"</td>
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
            </table>\"
        };
    "), info = "ylab, extra, color_groups, color_title")

})


test_that("get_categorical_domains", {
    params <- list(x = 1:10)
    lines <- Lines$new(params)
    lines$get_params()
    lines$get_data()
    expect_equal(no_whitespace(lines$get_categorical_domains()), "{x:null,y:null}")

    params <- list(x = letters[1:10], y = 1:10)
    lines <- Lines$new(params)
    lines$get_params()
    lines$get_data()
    expect_equal(no_whitespace(lines$get_categorical_domains()), "{x:[\"a\",\"b\",\"c\",\"d\",\"e\",\"f\",\"g\",\"h\",\"i\",\"j\"],y:null}")
})

test_that("get_data_ranges", {
    # when there is no y, x => y
    params <- list(x = 1:10)
    lines <- Lines$new(params)
    lines$get_data()
    expect_equal(no_whitespace(lines$get_data_ranges()), "{x:[1,10],y:[1,10]}", info = "numeric x")

    params <- list(x = 1)
    lines <- Lines$new(params)
    lines$get_data()
    expect_equal(no_whitespace(lines$get_data_ranges()), "{x:[0,2],y:[0,2]}", info = "numeric x, single number")

    # I don't think this is useful for lines
    # params <- list(x = factor(1:10, levels = 10:1), y = 1:10)
    # lines <- Lines$new(params)
    # lines$get_data()
    # expect_equal(no_whitespace(lines$get_data_ranges()), "{x:[\"10\",\"9\",\"8\",\"7\",\"6\",\"5\",\"4\",\"3\",\"2\",\"1\"],y:[1,10]}")

    params <- list(x = letters[1:10], y = 1:10)
    lines <- Lines$new(params)
    lines$get_data()
    expect_equal(no_whitespace(lines$get_data_ranges()), "{x:[\"a\",\"b\",\"c\",\"d\",\"e\",\"f\",\"g\",\"h\",\"i\",\"j\"],y:[1,10]}")
})
