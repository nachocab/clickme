# context("clickme_lines")

# test_that("validate lines params", {
#     params <- validate_lines_params(list(data = matrix(1:4, nrow = 4)))
#     expect_equal(params$line_names, as.character(1:4))

#     params <- validate_lines_params(list(data = list(line1 = c(1,2,3), line2 = c(1,2,3))))
#     expect_equal(params$line_names, c("line1", "line2"))

#     params <- validate_lines_params(list(data = list(c(1,2,3), c(1,2,3))))
#     expect_equal(params$line_names, c("1", "2"))

#     params <- validate_lines_params(list(data = 1:3))
#     expect_equal(params$line_names, "1")

# })

# test_that("reads the correct data input", {
#     # data is a vector
#     data <- get_lines_data(2:6, 2:6, list(line_names = "1"))
#     expect_equal(toJSON(data$formatted), "[{\"line_name\":\"1\",\"values\":[{\"x\":2,\"y\":2},{\"x\":3,\"y\":3},{\"x\":4,\"y\":4},{\"x\":5,\"y\":5},{\"x\":6,\"y\":6}]}]")

#     # data is a matrix
#     data <- matrix(1:9, nrow = 3, byrow = FALSE)
#     data <- get_lines_data(data, NULL, list(line_names = as.character(1:nrow(data))))
#     expect_equal(toJSON(data$formatted), "[{\"line_name\":\"1\",\"values\":[{\"x\":1,\"y\":1},{\"x\":2,\"y\":4},{\"x\":3,\"y\":7}]},{\"line_name\":\"2\",\"values\":[{\"x\":1,\"y\":2},{\"x\":2,\"y\":5},{\"x\":3,\"y\":8}]},{\"line_name\":\"3\",\"values\":[{\"x\":1,\"y\":3},{\"x\":2,\"y\":6},{\"x\":3,\"y\":9}]}]")

#     # data is a data frame
#     data <- data.frame(x1 = 1:3, x2 = 4:6, x3 = 7:9)
#     data <- get_lines_data(data, colnames(data), list(line_names = rownames(data)))
#     expect_equal(toJSON(data$formatted), "[{\"line_name\":\"1\",\"values\":[{\"x\":\"x1\",\"y\":1},{\"x\":\"x2\",\"y\":4},{\"x\":\"x3\",\"y\":7}]},{\"line_name\":\"2\",\"values\":[{\"x\":\"x1\",\"y\":2},{\"x\":\"x2\",\"y\":5},{\"x\":\"x3\",\"y\":8}]},{\"line_name\":\"3\",\"values\":[{\"x\":\"x1\",\"y\":3},{\"x\":\"x2\",\"y\":6},{\"x\":\"x3\",\"y\":9}]}]")

#     # data is a data frame with x
#     data <- data.frame(x1 = 1:3, x2 = 4:6, x3 = 7:9)
#     data <- get_lines_data(data, c(1,5,6), list(line_names = rownames(data)))
#     expect_equal(toJSON(data$formatted), "[{\"line_name\":\"1\",\"values\":[{\"x\":1,\"y\":1},{\"x\":5,\"y\":4},{\"x\":6,\"y\":7}]},{\"line_name\":\"2\",\"values\":[{\"x\":1,\"y\":2},{\"x\":5,\"y\":5},{\"x\":6,\"y\":8}]},{\"line_name\":\"3\",\"values\":[{\"x\":1,\"y\":3},{\"x\":5,\"y\":6},{\"x\":6,\"y\":9}]}]")

#     # data is a data frame with row names
#     data <- data.frame(x1 = 1:3, x2 = 4:6, x3 = 7:9)
#     data <- get_lines_data(data, colnames(data), list(line_names = letters[1:3]))
#     expect_equal(toJSON(data$formatted), "[{\"line_name\":\"a\",\"values\":[{\"x\":\"x1\",\"y\":1},{\"x\":\"x2\",\"y\":4},{\"x\":\"x3\",\"y\":7}]},{\"line_name\":\"b\",\"values\":[{\"x\":\"x1\",\"y\":2},{\"x\":\"x2\",\"y\":5},{\"x\":\"x3\",\"y\":8}]},{\"line_name\":\"c\",\"values\":[{\"x\":\"x1\",\"y\":3},{\"x\":\"x2\",\"y\":6},{\"x\":\"x3\",\"y\":9}]}]")

#     data <- data.frame(x1 = 1:3, x2 = 4:6, x3 = 7:9)
#     expect_error(get_lines_data(data, c(colnames(data), "extra"), list(line_names = rownames(data))), "You have provided more x-values than columns in your data: x1, x2, x3, extra")

#     # data is a matrix with colorize
#     data <- matrix(1:9, nrow = 3, byrow = FALSE)
#     data <- get_lines_data(data, NULL, list(colorize = c("a","a","b"), line_names = as.character(1:nrow(data))))
#     expect_equal(toJSON(data$formatted), "[{\"line_name\":\"3\",\"values\":[{\"x\":1,\"y\":3},{\"x\":2,\"y\":6},{\"x\":3,\"y\":9}],\"colorize\":\"b\"},{\"line_name\":\"1\",\"values\":[{\"x\":1,\"y\":1},{\"x\":2,\"y\":4},{\"x\":3,\"y\":7}],\"colorize\":\"a\"},{\"line_name\":\"2\",\"values\":[{\"x\":1,\"y\":2},{\"x\":2,\"y\":5},{\"x\":3,\"y\":8}],\"colorize\":\"a\"}]")

# })

