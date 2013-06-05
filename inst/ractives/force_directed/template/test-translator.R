context("translate force_directed")

test_that("data frames are translated to the format expected by the template", {
    opts <- get_opts("force_directed")
    opts$data <- data.frame(source = 1:4, target = 4:1, type = paste0("A", 1:4))
    expected_data <- "[{\"source\":1,\"target\":4,\"type\":\"A1\"},\n{\"source\":2,\"target\":3,\"type\":\"A2\"},\n{\"source\":3,\"target\":2,\"type\":\"A3\"},\n{\"source\":4,\"target\":1,\"type\":\"A4\"}]"

    json_data <- get_data_as_json(opts)

    expect_equal(json_data, expected_data)
})


