context("clickme_heatmap")


test_that("reads the correct data input", {
    data <- data.frame(x1 = 1:2, x2 = 3:4, row.names = letters[1:2])
    data <- get_heatmap_data(data, list(row_names = rownames(data), col_names = colnames(data)))
    expect_equal(toJSON(data$formatted), "[{\"col_values\":[{\"row_values\":[{\"cell_value\":1},{\"cell_value\":3}]},{\"row_values\":[{\"cell_value\":2},{\"cell_value\":4}]}],\"col_names\":[\"x1\",\"x2\"]}]")

    data <- data.frame(x1 = 1:2, x2 = 3:4, x3 = 5:6, row.names = letters[1:2])
    data <- get_heatmap_data(data, list(row_names = rownames(data), col_names = colnames(data), col_groups = c(1,2,2)))
    expect_equal(toJSON(data$formatted), "[{\"col_values\":[{\"row_values\":[{\"cell_value\":1}]},{\"row_values\":[{\"cell_value\":2}]}],\"col_names\":\"x1\",\"col_group_name\":\"1\"},{\"col_values\":[{\"row_values\":[{\"cell_value\":3},{\"cell_value\":5}]},{\"row_values\":[{\"cell_value\":4},{\"cell_value\":6}]}],\"col_names\":[\"x2\",\"x3\"],\"col_group_name\":\"2\"}]")
})

test_that("validate heatmap params", {
    params <- list(data = matrix(1:4, byrow = FALSE, nrow = 2))
    expect_equal(validate_heatmap_params(params)$col_names, c("1","2"))

    params <- list(data = data.frame(x1 = 1:2, x2 = 3:4, x3 = 5:6, row.names = letters[1:2]), row_names = rownames(data), col_names = colnames(data), col_groups = c(1,2,2,2))
    expect_error(validate_heatmap_params(params), "data has 3 columns, but col_groups contains 4 elements: 1, 2, 2, 2")

    params <- list(data = data.frame(x1 = 1:2, x2 = 3:4, x3 = 5:6, row.names = letters[1:2]), row_names = rownames(data), col_names = colnames(data), row_groups = c(1,2,2))
    expect_error(validate_heatmap_params(params), "data has 2 rows, but row_groups contains 3 elements: 1, 2, 2")

})

