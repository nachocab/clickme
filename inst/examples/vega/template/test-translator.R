context("translate vega")

test_that("input data is translated to the format expected by the template", {
    test_data_name <- "test_data"
    opts <- get_opts("vega", params=list(spec="area"), data_name = test_data_name)
    opts$data <- data.frame(x = c(1, 2, 3), y = c(10, 20, 30))
    expected_data <- "[{\"x\":1,\"y\":10},\n{\"x\":2,\"y\":20},\n{\"x\":3,\"y\":30}]"

    json_data <- get_data_as_json(opts)
    expect_equal(json_data, expected_data)

    opts$data <- list(x = c(1, 2, 3), y = c(10, 20, 30))
    json_data <- get_data_as_json(opts)
    expect_equal(json_data, expected_data)

    json_file <- get_data_as_json_file(opts)
    expect_correct_file(opts, "json", expected_data)

    csv_file <- get_data_as_csv_file(opts)
    expect_correct_file(opts, "csv")

})

test_that("spec is specified", {
    opts <- get_opts("vega")

    expect_error(get_spec_path_param(opts), "provide a Vega spec")

    expected_spec_path <- file.path(opts$path$data, "spec", "area.json")
    opts <- get_opts("vega", list(spec_path = expected_spec_path))
    spec_path <- get_spec_path_param(opts)
    expect_equal(spec_path, expected_spec_path)

    opts <- get_opts("vega", list(spec_path = "fake_spec.json"))
    expect_error(get_spec_path_param(opts), "No spec file was found")
})

test_that("padding", {
    # default global padding
    opts <- get_opts("vega", params=list(spec="area"))
    padding <- get_padding_param(opts)
    expect_equal(padding, "{\"top\":10,\"left\":30,\"bottom\":30,\"right\":10}")

    # spec-specific padding
    opts <- get_opts("vega", params=list(spec="area"))
    padding <- get_padding_param(opts, c(10,10,10,10))
    expect_equal(padding, "{\"top\":10,\"left\":10,\"bottom\":10,\"right\":10}")

    # user-provided param padding
    opts <- get_opts("vega", params=list(padding = c(10, 20, 30, 40), spec = "area"))
    padding <- get_padding_param(opts)
    expect_equal(padding, "{\"top\":10,\"left\":20,\"bottom\":30,\"right\":40}")

    # changed order
    opts <- get_opts("vega", params=list(padding=c(right=10,bottom=20,left=30,top=40), spec="area"))
    padding <- get_padding_param(opts)
    expect_equal(padding, "{\"right\":10,\"bottom\":20,\"left\":30,\"top\":40}")

    # wrong input
    opts <- get_opts("vega", params=list(padding=c(10,20,30), spec="area"))
    expect_error(get_padding_param(opts), "Please provide four padding values")
})
