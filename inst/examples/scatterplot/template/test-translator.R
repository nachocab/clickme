context("translate scatterplot")

test_that("input data is translated to the format expected by the template", {
    test_data_name <- "test_data"
    opts <- get_opts("scatterplot", data_name = test_data_name)
    opts$data <- data.frame(x=c(1,2,3), y=c(10,20,30), group=c("a","b","a"), name=c("A","B","C"))
    expected_data <- "[{\"x\":1,\"y\":10,\"group\":\"a\",\"name\":\"A\"},\n{\"x\":2,\"y\":20,\"group\":\"b\",\"name\":\"B\"},\n{\"x\":3,\"y\":30,\"group\":\"a\",\"name\":\"C\"}]"

    json_data <- get_data_as_json(opts)
    expect_equal(json_data, expected_data)

    opts$data <- data.frame(x=c(1,2,3), y=c(10,20,30))
    expected_data <- "[{\"x\":1,\"y\":10,\"group\":\"\",\"name\":\"1\"},\n{\"x\":2,\"y\":20,\"group\":\"\",\"name\":\"2\"},\n{\"x\":3,\"y\":30,\"group\":\"\",\"name\":\"3\"}]"

    json_data <- get_data_as_json(opts)
    expect_equal(json_data, expected_data)

    json_data <- get_data_as_json_file(opts)
    expect_correct_file(opts, "json", expected_data)
})

test_that("padding", {
    # user-provided param padding
    opts <- get_opts("vega", params=list(padding = c(10, 20, 30, 40, .05), spec = "area"))
    padding <- get_padding_param(opts)
    expect_equal(padding, "{\"top\":10,\"left\":20,\"bottom\":30,\"right\":40,\"scale\":0.05}")
})


