context("Template-config")

TestTemplate <- setRefClass('TestTemplate', contains = "Template", where=.GlobalEnv)
test_template_path <- file.path(getOption("clickme_templates_path"), "testtemplate")
dir.create(test_template_path)
file.create(file.path(test_template_path, "template.Rmd"))
file.create(file.path(test_template_path, "config.yml"))
file.create(file.path(test_template_path, "translator.R")) # Todo: remove this requirement


test_that("styles and scripts must be valid", {
    test_path <- file.path(test_template_path, "assets")
    dir.create(test_path)
    test_template <- TestTemplate$new(list(template_assets = test_path, shared_assets = test_path))
    test_template$get_params()
    test_template$get_file_structure()
    test_template$get_config()

    expect_that(test_template$validate_assets(), not(throws_error()))

    test_template$config$styles <- c("abc.css")
    expect_error(test_template$validate_assets(), "abc.css not found")
    file.create(file.path(test_path, "abc.css"))
    expect_that(test_template$validate_assets(), not(throws_error()))

    test_template$config$scripts <- c("$shared/abc.js")
    expect_error(test_template$validate_assets(), "abc.js not found")
    file.create(file.path(getOption("clickme_templates_path"), "__shared_assets", "abc.js"))
    expect_that(test_template$validate_assets(), not(throws_error()))
    unlink(file.path(getOption("clickme_templates_path"), "__shared_assets", "abc.js"))

    test_template$config$scripts <- c("http://d3js.org/d3.v3.min.js")
    expect_that(test_template$validate_assets(), not(throws_error()))

})

unlink(test_template_path, recursive = TRUE)
