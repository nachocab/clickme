context("Points placeholders")

#     # data <- get_points_data(1:5, NULL, params)


# test_that("the d3_color_scale can be categorical or quantitative", {
#     opts$data$color_groups <- c(1:5)
#     color_scale <- get_d3_color_scale(opts)

#     expected_color_scale <- "d3.scale.linear().domain([1,5]).range([\"steelblue\",\"#CA0020\"]).interpolate(d3.interpolateLab);"
#     expect_equal(gsub("\\s","", color_scale), expected_color_scale)

#     opts$data$color_groups <- c("a", "a", "b", "c", "b")
#     color_scale <- get_d3_color_scale(opts)


#     col1 <- "\"#2ca02c\""
#     col2 <- "\"#ff7f0e\""
#     col3 <- "\"#1f77b4\""
#     expected_color_scale <- paste0("d3.scale.ordinal().range([", col1, ",", col2, ",", col3, "]);")
#     expect_equal(color_scale, expected_color_scale)
# })

# test_that("the color_domain is calculated from the values of color_groups", {
#     opts$data$color_groups <- c(1, NA, 3, 5, 4)
#     color_domain <- get_color_domain_param(opts)

#     expect_equal(color_domain, "[1,5]")
# })

# test_that("the color_domain parameter can be set manually", {
#     params$color_domain <- c(2, 10)
#     color_domain <- get_color_domain_param(opts)

#     expect_equal(color_domain, "[2,10]")
# })




