context("append_xxx")

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
