context("xy_to_data")

# x is a numeric vector
test_that("x is a numeric vector and y is null", {
    data <- xy_to_data(x = 10:1, y = NULL)
    expect_equal(data, data.frame(x = 1:10, y = 10:1, row.names = as.character(1:10)))

    data <- xy_to_data(x = setNames(10:1, letters[1:10]), y = NULL)
    expect_equal(data, data.frame(x = 1:10, y = 10:1, row.names = letters[1:10]))

    # duplicate names() are not used as rownames
    data <- xy_to_data(x = setNames(10:1, rep("a", 10)), y = NULL)
    expect_equal(data, data.frame(x = 1:10, y = 10:1, row.names = as.character(1:10)))
})

test_that("x is a numeric vector and y is a numeric vector", {
    data <- xy_to_data(x = 10:1, y = 1:10)
    expect_equal(data, data.frame(x = 10:1, y = 1:10, row.names = as.character(1:10)))

    expect_error(xy_to_data(x = 10:1, y = 1:5), "x has 10 elements, but y has 5")
})

test_that("x is a numeric vector and y is a character vector", {
    data <- xy_to_data(x = 10:1, y = letters[1:10])
    expect_equal(data, data.frame(x = 10:1, y = letters[1:10], row.names = as.character(1:10)))

    data <- xy_to_data(x = 10:1, y = as.character(1:10))
    expect_equal(data, data.frame(x = 10:1, y = as.character(1:10), row.names = as.character(1:10)))
})

test_that("x is a numeric vector and y is a factor", {
    data <- xy_to_data(x = 10:1, y = factor(letters[1:10]))
    expect_equal(data, data.frame(x = 10:1, y = factor(letters[1:10]), row.names = as.character(1:10)))

    data <- xy_to_data(x = 10:1, y = factor(as.character(1:10)))
    expect_equal(data, data.frame(x = 10:1, y = factor(as.character(1:10)), row.names = as.character(1:10)))
})


# x is a character vector
test_that("x is a character vector and y is null", {
    expect_error(xy_to_data(x = c("a", "b", "c"), y = NULL), "y cannot be NULL when x is a character vector or a factor")
})

test_that("x is a character vector and y is a numeric vector", {
    data <- xy_to_data(x = letters[1:10], y = 1:10)
    expect_equal(data, data.frame(x = letters[1:10], y = 1:10, row.names = as.character(1:10)))

    data <- xy_to_data(x = as.character(1:10), y = 1:10)
    expect_equal(data, data.frame(x = as.character(1:10), y = 1:10, row.names = as.character(1:10)))

    data <- xy_to_data(x = setNames(as.character(1:10), letters[1:10]), y = 1:10)
    expect_equal(data, data.frame(x = as.character(1:10), y = 1:10, row.names = letters[1:10]))
})

test_that("x is a character vector and y is a character vector", {
    data <- xy_to_data(x = letters[1:10], y = as.character(1:10))
    expect_equal(data, data.frame(x = letters[1:10], y = as.character(1:10), row.names = as.character(1:10)))

    data <- xy_to_data(x = as.character(1:10), y = letters[1:10])
    expect_equal(data, data.frame(x = as.character(1:10), y = letters[1:10], row.names = as.character(1:10)))
})

test_that("x is a character vector and y is a factor", {
    data <- xy_to_data(x = letters[1:10], y = factor(1:10))
    expect_equal(data, data.frame(x = letters[1:10], y = factor(1:10), row.names = as.character(1:10)))

    data <- xy_to_data(x = as.character(1:10), y = factor(letters[1:10]))
    expect_equal(data, data.frame(x = as.character(1:10), y = factor(letters[1:10]), row.names = as.character(1:10)))
})

test_that("x is a character vector and y is a data frame with as many numeric columns as elements in x", {
    data <- xy_to_data(x = letters[1:3], y = data.frame("1" = 1:10, "2" = 11:20, "3" = 21:30))
    expect_equal(data, data.frame(x = rep(letters[1:3], each = 10), y = 1:30, row.names = as.character(1:30)))
    expect_error(xy_to_data(x = letters[1:3], y = data.frame("1" = 1:10, "2" = 11:20)), "x has 3 elements, but y has 2 columns")
})

test_that("x is a character vector and y is a matrix with as many numeric columns as elements in x", {
    data <- xy_to_data(x = letters[1:3], y = matrix(1:30, ncol = 3))
    expect_equal(data, data.frame(x = rep(letters[1:3], each = 10), y = 1:30, row.names = as.character(1:30)))
    expect_error(xy_to_data(x = letters[1:3], y = matrix(1:30, ncol = 2)), "x has 3 elements, but y has 2 columns")
})

# x is a factor
test_that("x is a factor and y is null", {
    expect_error(xy_to_data(x = c("a", "b", "c"), y = NULL), "y cannot be NULL when x is a character vector or a factor")
})

test_that("x is a factor and y is a numeric vector", {
    data <- xy_to_data(x = factor(letters[1:10]), y = 1:10)
    expect_equal(data, data.frame(x = factor(letters[1:10]), y = 1:10, row.names = as.character(1:10)))

    data <- xy_to_data(x = factor(as.character(1:10)), y = 1:10)
    expect_equal(data, data.frame(x = factor(as.character(1:10)), y = 1:10, row.names = as.character(1:10)))
})

test_that("x is a factor and y is a character vector", {
    data <- xy_to_data(x = factor(letters[1:10]), y = as.character(1:10))
    expect_equal(data, data.frame(x = factor(letters[1:10]), y = as.character(1:10), row.names = as.character(1:10)))

    data <- xy_to_data(x = factor(as.character(1:10)), y = letters[1:10])
    expect_equal(data, data.frame(x = factor(as.character(1:10)), y = letters[1:10], row.names = as.character(1:10)))
})

test_that("x is a factor and y is a factor", {
    data <- xy_to_data(x = factor(letters[1:10]), y = factor(as.character(1:10)))
    expect_equal(data, data.frame(x = factor(letters[1:10]), y = factor(as.character(1:10)), row.names = as.character(1:10)))

    data <- xy_to_data(x = factor(as.character(1:10)), y = factor(letters[1:10]))
    expect_equal(data, data.frame(x = factor(as.character(1:10)), y = factor(letters[1:10]), row.names = as.character(1:10)))
})

test_that("x is a factor and y is a data frame with as many numeric columns as elements in x", {
    data <- xy_to_data(x = factor(letters[1:3]), y = data.frame("1" = 1:10, "2" = 11:20, "3" = 21:30))
    expect_equal(data, data.frame(x = factor(rep(letters[1:3], each = 10)), y = 1:30, row.names = as.character(1:30)))

    expect_error(xy_to_data(x = factor(letters[1:3]), y = data.frame("1" = 1:10, "2" = 11:20)), "x has 3 elements, but y has 2 columns")
})

test_that("x is a factor and y is a matrix with as many numeric columns as elements in x", {
    data <- xy_to_data(x = factor(letters[1:3]), y = matrix(1:30, ncol = 3))
    expect_equal(data, data.frame(x = factor(rep(letters[1:3], each = 10)), y = 1:30, row.names = as.character(1:30)))
    expect_error(xy_to_data(x = factor(letters[1:3]), y = matrix(1:30, ncol = 2)), "x has 3 elements, but y has 2 columns")
})



# x is a data frame
test_that("x is a data frame with only one column", {
    expect_error(xy_to_data(x = data.frame(a=1:10), y = NULL), "When x is a dataframe or a matrix, it must contain at least two columns")
})

test_that("x is a data frame with two columns and y is null", {
    data <- xy_to_data(x = data.frame(a = factor(as.character(1:10)), b = 1:10), y = NULL)
    expect_equal(data, data.frame(x = factor(as.character(1:10)), y = 1:10, row.names = as.character(1:10)))

    data <- xy_to_data(x = data.frame(a = factor(as.character(1:10)), b = 1:10, row.names = letters[1:10]), y = NULL)
    expect_equal(data, data.frame(x = factor(as.character(1:10)), y = 1:10, row.names = letters[1:10]))
})

test_that("x is a data frame with three numeric columns or more and y is null", {
    data <- xy_to_data(x = data.frame(a = 1:10, b = 11:20, c = 21:30), y = NULL)
    expect_equal(data, data.frame(x = rep(c("a","b","c"), each = 10), y = 1:30, row.names = as.character(1:30)))

    expect_message(xy_to_data(x = data.frame(a = letters[1:10], b = 11:20, c = 21:30), y = NULL), "x is not numeric and it has more than two columns, using the first two: a, b")
})

# x is a matrix
test_that("x is a matrix with only one column", {
    expect_error(xy_to_data(x = cbind(1:10), y = NULL), "When x is a dataframe or a matrix, it must contain at least two columns")
})

test_that("x is a matrix with at least two columns and y is null", {
    data <- xy_to_data(x = matrix(1:20, nrow = 10), y = NULL)
    expect_equal(data, data.frame(x = 1:10, y = 11:20, row.names = as.character(1:10)))

    mat <- matrix(1:20, nrow = 10)
    rownames(mat) <- letters[1:10]
    data <- xy_to_data(x = mat, y = NULL)
    expect_equal(data, data.frame(x = 1:10, y = 11:20, row.names = letters[1:10]))
})

# x is a list
test_that("x is a list with only one element", {
    expect_error(xy_to_data(x = list(1:10), y = NULL), "When x is a list, it must contain at least two elements")
})

test_that("x is a list with at least two elements and y is null", {

    data <- xy_to_data(x = list(a = 1:10, b = 11:20), y = NULL)
    expect_equal(data, data.frame(x = 1:10, y = 11:20, row.names = as.character(1:10)))

    expect_error(xy_to_data(x = list(a = 1:10, b = list(1:5), y = NULL), "The first two elements of x have different lengths"))
})

