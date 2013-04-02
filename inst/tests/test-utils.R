context("styles and scripts")

test_that("appends styles and scripts", {
    set_root_path(system.file("examples", package="clickme"))
    ractive <- "par_coords"
    opts <- get_opts(ractive, data_name = "data")
    opts$template_config$scripts <- c("d3.min.js","d3.parcoords.js")
    opts$template_config$styles <- c("d3.parcoords.css","style.css")

    expected_scripts <- "<script src=\"par_coords/external/d3.min.js\"></script>\n<script src=\"par_coords/external/d3.parcoords.js\"></script>"
    expect_equal(append_scripts(opts), expected_scripts)

    expected_styles <- "<link href=\"par_coords/external/d3.parcoords.css\" rel=\"stylesheet\">\n<link href=\"par_coords/external/style.css\" rel=\"stylesheet\">"
    expect_equal(append_styles(opts), expected_styles)

    expected_styles_and_scripts <- "<link href=\"par_coords/external/d3.parcoords.css\" rel=\"stylesheet\">\n<link href=\"par_coords/external/style.css\" rel=\"stylesheet\">\n<script src=\"par_coords/external/d3.min.js\"></script>\n<script src=\"par_coords/external/d3.parcoords.js\"></script>"
    expect_equal(append_styles_and_scripts(opts), expected_styles_and_scripts)
})

test_that("create data file", {
    set_root_path(system.file("examples", package="clickme"))
    ractive <- "par_coords"
    opts <- get_opts(ractive, data_name = "test_data")

    data <- "[{\"a\":3,\"b\":5}]"
    data_file <- create_data_file(data, opts, "json")
    expect_equal(data_file, file.path(opts$relative_path$data, "test_data.json"))
    data_file_path <- file.path(opts$path$data, "test_data.json")
    expect_true(file.exists(data_file_path))
    expect_equal(readContents(data_file_path), data)

    unlink(file.path(opts$path$data, data_file))

    data <- data.frame(a=c(1,2), b=c(3,4))
    data_file <- create_data_file(data, opts, "csv")
    data_file_path <- file.path(opts$path$data, "test_data.csv")
    expect_true(file.exists(data_file_path))
    expect_equal(readContents(data_file_path), "\"a\",\"b\"\n1,3\n2,4")

    unlink(file.path(opts$path$data, data_file))
})
