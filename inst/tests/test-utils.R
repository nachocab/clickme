context("utils")

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
    expect_equal(append_external(opts), expected_styles_and_scripts)
})

test_that("create data file", {
    set_root_path(system.file("examples", package="clickme"))
    ractive <- "par_coords"
    opts <- get_opts(ractive, data_name = "test_data")
    opts$data <- "[{\"a\":3,\"b\":5}]"

    json_file <- create_data_file(opts, "json", quote_escaped = FALSE)
    expect_equal(json_file, file.path(opts$relative_path$data, "test_data.json"))
    expect_correct_file(opts, "json", opts$data)

    opts$data <- data.frame(a=c(1,2), b=c(3,4))
    csv_file <- create_data_file(opts, "csv", quote_escaped = FALSE)
    expect_correct_file(opts, "csv", "\"a\",\"b\"\n1,3\n2,4")
})

test_that("clickme_vega", {
    set_root_path(system.file("examples", package="clickme"))
    ractive <- "vega"

    # we do this to ensure that the HTML file doesn't exist before we create it
    spec <- "area"
    opts <- get_opts(ractive, params = list(spec = spec))
    unlink(opts$path$html_file)
    data <- read.csv(file.path(opts$path$data, "area_bar_scatter.csv"))

    opts <- clickme_vega(data, "area", browse = FALSE)

    expect_equal(opts$name$html_file, "data_area-vega.html")
    expect_true(file.exists(opts$path$html_file))

    opts <- clickme_vega(data, "area", data_name = "my_data", params = list(width=401), browse = FALSE)

    expect_equal(opts$params$spec, "area")
    expect_equal(opts$params$width, 401)
    unlink(opts$path$html_file)

    opts <- clickme_vega(data, "area", data_name = "my_data", browse = FALSE)

    expect_equal(opts$data_name, "my_data")
    expect_equal(opts$name$html_file, "my_data-vega.html")
    unlink(opts$path$html_file)
})
