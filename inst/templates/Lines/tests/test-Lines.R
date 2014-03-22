context("lines")

test_that("get_data works", {
    params <- list(x = 1:10)
    lines <- lines$new(params)
    lines$get_data()
    expect_equal(lines$data, 1:10)
})

