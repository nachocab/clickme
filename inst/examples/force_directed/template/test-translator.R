context("translate force_directed")

test_that("data frames are translated to the format expected by the template", {
    opts <- get_opts("force_directed")
    opts$data <- data.frame(a = 1:4, b = 4:1, type = letters[1:4])
    expected_data <- "[{\"a\":1,\"b\":4,\"type\":\"a\"},\n{\"a\":2,\"b\":3,\"type\":\"b\"},\n{\"a\":3,\"b\":2,\"type\":\"c\"},\n{\"a\":4,\"b\":1,\"type\":\"d\"}]"

    json_data <- get_data_as_json(opts)

    expect_equal(json_data, expected_data)
})


