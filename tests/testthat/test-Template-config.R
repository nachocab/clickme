context("Template-config")

TestTemplate <- setRefClass('TestTemplate', contains = "Template", where=.GlobalEnv)
test_template_path <- file.path(getOption("clickme_templates_path"), "testtemplate")
dir.create(test_template_path)
file.create(file.path(test_template_path, "template.Rmd"))
file.create(file.path(test_template_path, "config.yml"))
file.create(file.path(test_template_path, "translator.R")) # Todo: remove this requirement

test_that("styles and scripts must be valid", {

    test_template <- TestTemplate$new()
    test_template$get_params()
    test_template$get_file_structure()

    dir.create(test_template$file_structure$paths$template_assets)
    expect_that(test_template$get_config(), not(throws_error()))

    test_template$config$styles <- c("abc.css")
    expect_error(test_template$validate_config(), "abc.css not found")
    file.create(file.path(test_template$file_structure$paths$template_assets, "abc.css"))
    expect_that(test_template$validate_config(), not(throws_error()))

    test_template$config$scripts <- c("$shared/abc.js")
    expect_error(test_template$validate_config(), "abc.js not found")
    file.create(file.path(test_template$file_structure$paths$shared_assets, "abc.js"))
    expect_that(test_template$validate_config(), not(throws_error()))
    unlink(file.path(test_template$file_structure$paths$shared_assets, "abc.js"))

    test_template$config$scripts <- c("http://d3js.org/d3.v3.min.js")
    expect_that(test_template$validate_config(), not(throws_error()))

})

unlink(test_template_path, recursive = TRUE)
