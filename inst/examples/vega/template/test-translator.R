context("translate vega")

test_that("input data is translated to the format expected by the template", {
    test_data_prefix <- "test_data"
    opts <- get_opts("vega", params = list(spec="area"), data_prefix = test_data_prefix)
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

    expected_spec_path <- file.path(opts$path$template, "spec", "area.json")
    opts <- get_opts("vega", list(spec_path = expected_spec_path))
    spec_path <- get_spec_path_param(opts)
    expect_equal(spec_path, expected_spec_path)

    opts <- get_opts("vega", list(spec_path = "fake_spec.json"))
    expect_error(get_spec_path_param(opts), "No spec file was found")
})

