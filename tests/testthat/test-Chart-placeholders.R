context("Chart-placeholders")

test_chart_path <- file.path(getOption("clickme_templates_path"), "TestChart")
unlink(test_chart_path, recursive = TRUE)
TestChart <- setRefClass('TestChart', contains = "Chart", where=.GlobalEnv)
suppressMessages(new_template("TestChart"))

test_that("appends styles and scripts", {

    test_chart <- TestChart$new()
    test_chart$get_params()
    test_chart$get_file_structure()
    test_chart$get_config()

    test_chart$internal$config$styles <- c("abc.css", "$shared/def.css", "http://some_file.css")
    test_chart$internal$config$scripts <- c("abc.js", "$shared/def.js", "http://some_file.js")

    expected_styles <- paste("<link href=\"clickme_assets/TestChart/abc.css\" rel=\"stylesheet\">",
                             "<link href=\"clickme_assets/def.css\" rel=\"stylesheet\">",
                             "<link href=\"http://some_file.css\" rel=\"stylesheet\">",
                             sep = "\n")
    expected_scripts <- paste("<script src=\"clickme_assets/TestChart/abc.js\"></script>",
                              "<script src=\"clickme_assets/def.js\"></script>",
                              "<script src=\"http://some_file.js\"></script>",
                              sep = "\n")

    expected_styles_and_scripts <- paste0(c(expected_styles, expected_scripts), collapse = "\n")
    assets <- test_chart$get_assets()
    expect_equal(assets, expected_styles_and_scripts)
})

unlink(test_chart_path, recursive = TRUE)
