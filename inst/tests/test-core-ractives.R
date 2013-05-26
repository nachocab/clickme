context("clickme_points call")

suppressMessages(set_root_path(system.file("examples", package="clickme")))

test_that("clickme_points reads the correct data input", {

    # x is a vector, no y
    opts <- clickme_points(1:10, open = FALSE)
    expect_equal(opts$data, data.frame(x = 1:10, y = 1:10, name = as.character(1:10)))

    # x is a vector, y is a vector
    opts <- clickme_points(2:4, 5:7, open = FALSE)
    expect_equal(opts$data, data.frame(x = 2:4, y = 5:7, name = as.character(1:3)))

    # x is a data frame (x, y, no names), no y
    opts <- clickme_points(data.frame(x = 2:4, y = 5:7, row.names = LETTERS[1:3]), open = FALSE)
    expect_equal(opts$data, data.frame(x = 2:4, y = 5:7, name = LETTERS[1:3]))

    # x is a data frame (x, y, name, extra column), no y
    opts <- clickme_points(data.frame(x = 2:4, y = 5:7, name = LETTERS[1:3], extra = 11:13), open = FALSE)
    expect_equal(opts$data, data.frame(x = 2:4, y = 5:7, name = LETTERS[1:3]))

    # x is a matrix (x, y, names), no y
    mat <- cbind(x = 2:4, y = 5:7)
    rownames(mat) <- LETTERS[1:3]
    opts <- clickme_points(mat, open = FALSE)
    expect_equal(opts$data, data.frame(x = 2:4, y = 5:7, name = LETTERS[1:3]))

    # x is a list (x, y, no names, uneven-size element), no y
    opts <- clickme_points(list(x = 2:4, y = 5:7, extra = 1:10), open = FALSE)
    expect_equal(opts$data, data.frame(x = 2:4, y = 5:7, name = as.character(1:3)))

})

test_that("base::plot variable names are handled correctly", {

    opts <- clickme_points(1:10, main = "paco", open = FALSE)
    expect_equal(opts$params$title, "paco")

})

