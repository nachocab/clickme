context("json")

test_that("empty variables", {
    data <- ""
    expect_equal(to_json(data), "\"\"", info = "\"\"")

    data <- numeric()
    expect_equal(to_json(data), "[]", info = "numeric()")

    data <- character()
    expect_equal(to_json(data), "[]", info = "character()")

    data <- character(0)
    expect_equal(to_json(data), "[]", info = "character()")

    data <- logical()
    expect_equal(to_json(data), "[]", info = "logical()")

    data <- list()
    expect_equal(to_json(data), "[]", info = "list()")

    data <- matrix()
    expect_equal(to_json(data), "[]", info = "matrix()")

    data <- data.frame()
    expect_equal(to_json(data), "[]", info = "data.frame()")

    data <- array()
    expect_equal(to_json(data), "[]", info = "array()")

    data <- factor()
    expect_equal(to_json(data), "[]", info = "factor()")

    data <- NULL # same as c()
    expect_equal(to_json(data), "null", info = "NULL")

    data <- NA
    expect_equal(to_json(data), "NaN", info = "NA")

    data <- Inf
    expect_equal(to_json(data), "Infinity", info = "Inf")

    data <- -Inf
    expect_equal(to_json(data), "-Infinity", info = "-Inf")
})

test_that("vectors of length 1", {
    data <- 1
    expect_equal(to_json(data), "1", info = "single number")
    data <- "1"
    expect_equal(to_json(data), "\"1\"", info = "single character")

    data <- array(1)
    expect_equal(to_json(data), "[1]", info = "array single number")
    data <- array("1")
    expect_equal(to_json(data), "[\"1\"]", info = "array single character")

    data <- matrix(1)
    expect_equal(to_json(data), "[1]", info = "matrix single number")
    data <- matrix("1")
    expect_equal(to_json(data), "[\"1\"]", info = "matrix single character")

    data <- list(1)
    expect_equal(to_json(data), "[1]", info = "list single number")
    data <- list("1")
    expect_equal(to_json(data), "[\"1\"]", info = "list single character")

    data <- factor(1)
    expect_equal(to_json(data), "[\"1\"]", info = "factor single number")
    data <- factor("1")
    expect_equal(to_json(data), "[\"1\"]", info = "factor single character")
})

test_that("logical", {
    data <- TRUE
    expect_equal(to_json(data), "true")

    data <- FALSE
    expect_equal(to_json(data), "false")
})

test_that("data frame", {
    data <- data.frame(x = c(1, 2, 3), y = c("a", "b", "c"))
    expect_equal(to_json(data), "[{\"x\":1,\"y\":\"a\"},\n{\"x\":2,\"y\":\"b\"},\n{\"x\":3,\"y\":\"c\"}]")
})

test_that("matrix", {
    data <- matrix(1:9, nrow = 3, byrow = TRUE)
    expect_equal(to_json(data), "[[1,2,3],[4,5,6],[7,8,9]]")
})
