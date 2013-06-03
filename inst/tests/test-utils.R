context("utils")

suppressMessages(set_root_path(system.file("ractives", package="clickme")))

test_that("appends styles and scripts", {
    ractive <- "par_coords"
    opts <- get_opts(ractive, data_prefix = "data")
    opts$template_config$scripts <- c("shared/d3.min.js","main.js")
    opts$template_config$styles <- c("shared/bootstrap.css","main.css")

    expected_scripts <- "<script src=\"shared/d3.min.js\"></script>\n<script src=\"par_coords/external/main.js\"></script>"
    expect_equal(get_scripts(opts), expected_scripts)

    expected_styles <- "<link href=\"shared/bootstrap.css\" rel=\"stylesheet\">\n<link href=\"par_coords/external/main.css\" rel=\"stylesheet\">"
    expect_equal(get_styles(opts), expected_styles)

    expected_styles_and_scripts <- paste0(expected_styles, expected_scripts, collapse = "\n")
    expect_equal(get_external(opts), expected_styles_and_scripts)
})

test_that("create_data_file", {
    ractive <- "par_coords"
    opts <- get_opts(ractive, data_prefix = "test_data")
    opts$data <- "[{\"a\":3,\"b\":5}]"

    json_file <- create_data_file(opts, "json", quote_escaped = FALSE)
    expect_equal(json_file, file.path(opts$relative_path$data, "test_data.json"))
    expect_correct_file(opts, "json", opts$data)

    opts$data <- data.frame(a = c(1, 2), b = c(3, 4))
    csv_file <- create_data_file(opts, "csv", quote_escaped = FALSE)
    expect_correct_file(opts, "csv", "\"a\",\"b\"\n1,3\n2,4")
})


test_that("get_padding_param", {
    # default global padding
    opts <- get_opts("par_coords")
    padding <- get_padding_param(opts)
    expect_equal(padding, "{\"top\":100,\"right\":100,\"bottom\":100,\"left\":100}")

    # spec-specific padding
    opts <- get_opts("par_coords")
    opts$params$padding <- NULL
    padding <- get_padding_param(opts, c(10, 10, 10, 10))
    expect_equal(padding, "{\"top\":10,\"right\":10,\"bottom\":10,\"left\":10}")

    # user-provided param padding
    opts <- get_opts("par_coords", params = list(padding = c(10, 20, 30, 40)))
    padding <- get_padding_param(opts)
    expect_equal(padding, "{\"top\":10,\"right\":20,\"bottom\":30,\"left\":40}")

    # changed order
    opts <- get_opts("par_coords", params = list(padding = c(right = 10, bottom = 20, left = 30, top = 40)))
    padding <- get_padding_param(opts)
    expect_equal(padding, "{\"right\":10,\"bottom\":20,\"left\":30,\"top\":40}")

    # wrong input
    opts <- get_opts("par_coords", params = list(padding = c(10, 20, 30)))
    expect_error(get_padding_param(opts), "Please provide four padding values")
})

test_that("scale_type", {
    expect_equal(scale_type(NULL), "categorical")
    expect_equal(scale_type(c(1)), "categorical")
    expect_equal(scale_type(c("a")), "categorical")
    expect_equal(scale_type(c("a", "b", "c")), "categorical")
    expect_equal(scale_type(c(1, 2, 3)), "quantitative")
})

