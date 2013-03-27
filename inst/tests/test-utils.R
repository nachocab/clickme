context("append_xxx")

test_that("appends valid styles and scripts", {
    set_root_path(system.file("examples", package="clickme"))
    ractive <- "force_directed"
    opts <- get_opts(ractive, data_name = "data")
    opts$template_config$scripts <- c("abc.js","def.js")
    opts$template_config$styles <- c("abc.css","def.css")

    expected_scripts <- "<script src=\"force_directed/external/abc.js\"></script>\n<script src=\"force_directed/external/def.js\"></script>"
    expect_equal(append_scripts(opts), expected_scripts)

    expected_styles <- "<link href=\"force_directed/external/abc.css\" rel=\"stylesheet\">\n<link href=\"force_directed/external/def.css\" rel=\"stylesheet\">"
    expect_equal(append_styles(opts), expected_styles)

    expected_styles_and_scripts <- "<link href=\"force_directed/external/abc.css\" rel=\"stylesheet\">\n<link href=\"force_directed/external/def.css\" rel=\"stylesheet\">\n<script src=\"force_directed/external/abc.js\"></script>\n<script src=\"force_directed/external/def.js\"></script>"
    expect_equal(append_styles_and_scripts(opts), expected_styles_and_scripts)
})

context("translate test_translator")

test_that("data frames are translated to the format expected by the template", {
    input_data <- data.frame(line = rep(c("l1", "l2"), each = 2), x = 1:4, y = 11:14)
    expected_data <- list(
                          list(key = "l1",
                               values = list(
                                             list(x = 1, y = 11),
                                             list(x = 2, y = 12)
                                        )
                          ),
                          list(key = "l2",
                               values = list(
                                             list(x = 3, y = 13),
                                             list(x = 4, y = 14)
                                        )
                          )
                     )

    translated_input <- prepare_data(input_data)
    expect_equal(translated_input, expected_data)
})