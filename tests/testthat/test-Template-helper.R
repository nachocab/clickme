context("Template-helper")

TestTemplate <- setRefClass('TestTemplate', contains = "Template", where=.GlobalEnv)
test_template_path <- file.path(getOption("clickme_templates_path"), "TestTemplate")
suppressMessages(new_template("TestTemplate"))

test_that("appends styles and scripts", {

    test_template <- TestTemplate$new()
    test_template$get_params()
    test_template$get_file_structure()
    test_template$get_config()

    test_template$config$styles <- c("abc.css", "$shared/def.css", "http://some_file.css")
    test_template$config$scripts <- c("abc.js", "$shared/def.js", "http://some_file.js")

    expected_styles <- paste("<link href=\"clickme_assets/TestTemplate/abc.css\" rel=\"stylesheet\">",
                             "<link href=\"clickme_assets/def.css\" rel=\"stylesheet\">",
                             "<link href=\"http://some_file.css\" rel=\"stylesheet\">",
                             sep = "\n")
    expected_scripts <- paste("<script src=\"clickme_assets/TestTemplate/abc.js\"></script>",
                              "<script src=\"clickme_assets/def.js\"></script>",
                              "<script src=\"http://some_file.js\"></script>",
                              sep = "\n")

    expected_styles_and_scripts <- paste0(c(expected_styles, expected_scripts), collapse = "\n")
    assets <- test_template$get_assets()
    expect_equal(assets, expected_styles_and_scripts)
})

unlink(test_template_path, recursive = TRUE)
