context("utils")

suppressMessages(set_root_path(system.file("examples", package="clickme")))

test_that("appends styles and scripts", {
    ractive <- "par_coords"
    opts <- get_opts(ractive, data_prefix = "data")
    opts$template_config$scripts <- c("d3.min.js","d3.parcoords.js")
    opts$template_config$styles <- c("d3.parcoords.css","style.css")

    expected_scripts <- "<script src=\"par_coords/external/d3.min.js\"></script>\n<script src=\"par_coords/external/d3.parcoords.js\"></script>"
    expect_equal(get_scripts(opts), expected_scripts)

    expected_styles <- "<link href=\"par_coords/external/d3.parcoords.css\" rel=\"stylesheet\">\n<link href=\"par_coords/external/style.css\" rel=\"stylesheet\">"
    expect_equal(get_styles(opts), expected_styles)

    expected_styles_and_scripts <- "<link href=\"par_coords/external/d3.parcoords.css\" rel=\"stylesheet\">\n<link href=\"par_coords/external/style.css\" rel=\"stylesheet\">\n<script src=\"par_coords/external/d3.min.js\"></script>\n<script src=\"par_coords/external/d3.parcoords.js\"></script>"
    expect_equal(get_external(opts), expected_styles_and_scripts)
})

test_that("create data file", {
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


test_that("padding", {
    # default global padding
    opts <- get_opts("par_coords")
    padding <- get_padding_param(opts)
    expect_equal(padding, "{\"top\":24,\"right\":0,\"bottom\":12,\"left\":200}")

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

# test_that("get_data_names", {
#     names <- c("a", "b", "c")
#     m <- matrix(1:9, ncol=3)
#     colnames(m) <- names
#     expect_equal(get_data_names(m), names)

#     d <- data.frame(m)
#     rownames(d) <- c("A","B","C")
#     expect_equal(get_data_names(d), names)

#     l <- list(a = 3, b = 33, c = 333)
#     expect_equal(get_data_names(l), names)

#     v <- c(a = 3, b = 33, c = 333)
#     expect_equal(get_data_names(v), names)

#     f <- factor(c(a = 3, b = 33, c = 333))
#     expect_equal(get_data_names(f), names)
# })
