context("translate force_directed")

test_that("data frames are translated to the format expected by the template", {
    input_data <- data.frame(a = 1:4, b = 4:1, type = letters[1:4])
    expected_data <- "[{\"a\":1,\"b\":4,\"type\":\"a\"},\n{\"a\":2,\"b\":3,\"type\":\"b\"},\n{\"a\":3,\"b\":2,\"type\":\"c\"},\n{\"a\":4,\"b\":1,\"type\":\"d\"}]"

    opts <- get_opts("force_directed")
    opts <- translate(input_data, opts)

    expect_equal(opts$data, expected_data)
})


