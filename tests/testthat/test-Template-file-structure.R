context("Template-file-structure")

TestTemplate <- setRefClass('TestTemplate', contains = "Template", where=.GlobalEnv)
test_template_path <- file.path(getOption("clickme_templates_path"), "TestTemplate")
test_template <- TestTemplate$new()
test_template$get_params()

test_that("default paths are valid", {

    test_template$get_unvalidated_file_structure()
    expect_error(test_template$validate_file_structure(), gettextf("There is no template TestTemplate located in: %s", test_template_path) )
    dir.create(test_template_path)

    expect_error(test_template$validate_file_structure(), gettextf("The TestTemplate template doesn't contain a template file in: %s", file.path(test_template_path, "template", "template.Rmd")))
    dir.create(file.path(test_template_path, "template"))
    file.create(file.path(test_template_path, "template", "template.Rmd"))

    expect_error(test_template$validate_file_structure(), gettextf("The TestTemplate template doesn't contain a configuration file in: %s", file.path(test_template_path, "config.yml")))
    file.create(file.path(test_template_path, "config.yml"))

    expect_error(test_template$validate_file_structure(), gettextf("The TestTemplate template doesn't contain a translator file in: %s", file.path(test_template_path, "translator", "TestTemplate.R")))
    dir.create(file.path(test_template_path, "translator"))
    file.create(file.path(test_template_path, "translator", "TestTemplate.R"))

    dir_path <- file.path(system.file("output", package = "clickme"), "output_test")
    test_template <- TestTemplate$new(list(dir = dir_path))
    test_template$get_params()
    test_template$get_file_structure()
    expect_true(file.exists(dir_path))

    # folders
    expect_equal(test_template$file_structure$paths$template, test_template_path)
    expect_equal(test_template$file_structure$paths$template_template, file.path(test_template_path, "template"))
    expect_equal(test_template$file_structure$paths$translator, file.path(test_template_path, "translator"))
    expect_equal(test_template$file_structure$paths$tests, file.path(test_template_path, "tests"))
    expect_equal(test_template$file_structure$paths$template_assets, file.path(test_template_path, "assets"))

    # files
    expect_equal(test_template$file_structure$paths$template_file, file.path(test_template$file_structure$paths$template_template, "template.Rmd"))
    expect_equal(test_template$file_structure$paths$config_file, file.path(test_template$file_structure$paths$template, "config.yml"))
    expect_equal(test_template$file_structure$paths$translator_file, file.path(test_template$file_structure$paths$translator, "TestTemplate.R"))
    expect_equal(test_template$file_structure$paths$translator_test_file, file.path(test_template$file_structure$paths$tests, "test-TestTemplate.R"))

    test_template <- TestTemplate$new(list(coffee = TRUE))
    test_template$get_params()
    test_template$get_unvalidated_file_structure()
    unlink(file.path(test_template_path, "template", "template.Rmd"))
    expect_error(test_template$validate_file_structure(), gettextf("The TestTemplate template doesn't contain a template file in: %s", test_template$file_structure$paths$template))

    file.create(file.path(test_template$file_structure$paths$template_template, "template.coffee.Rmd"))
    expect_that(test_template$validate_file_structure(), not(throws_error()))
    expect_equal(test_template$file_structure$paths$template_coffee_file, file.path(test_template$file_structure$paths$template_template, "template.coffee.Rmd"))

    file.create(file.path(test_template$file_structure$paths$template_template, "template.Rmd"))

    unlink(dir_path, recursive = TRUE)
})


test_that("output file name is added", {
    expect_equal(test_template$file_structure$names$output_file, "temp-TestTemplate.html")

    test_template <- TestTemplate$new(list(file = file.path("my_folder", "my_file.html")))
    test_template$get_params()
    test_template$get_file_structure()
    expect_equal(test_template$file_structure$names$output_file, "my_file.html")

    test_template <- TestTemplate$new(list(file = file.path("my_folder", "my_file")))
    test_template$get_params()
    test_template$get_file_structure()
    expect_equal(test_template$file_structure$names$output_file, "my_file.html")

    test_template <- TestTemplate$new(list(file = "my_file.html"))
    test_template$get_params()
    test_template$get_file_structure()
    expect_equal(test_template$file_structure$names$output_file, "my_file.html")

    test_template <- TestTemplate$new(list(file = "my_file"))
    test_template$get_params()
    test_template$get_file_structure()
    expect_equal(test_template$file_structure$names$output_file, "my_file.html")

    test_template <- TestTemplate$new(list(file = file.path("my_folder", "my_file1.html"), file_name = "my_file2.html"))
    test_template$get_params()
    expect_warning(test_template$get_file_structure(), "The \"file_name\" argument was ignored because the \"file\" argument was present: ")
    expect_equal(test_template$file_structure$names$output_file, "my_file1.html")
})

test_that("output paths are added", {
    test_template <- TestTemplate$new()
    test_template$get_params()
    test_template$get_file_structure()

    expect_equal(test_template$file_structure$paths$output, system.file("output", package = "clickme"))
    expect_equal(test_template$file_structure$paths$output_file, file.path(test_template$file_structure$paths$output, test_template$file_structure$names$output_file))

    expect_equal(test_template$file_structure$paths$shared_assets, file.path(getOption("clickme_templates_path"), "..", "shared_assets"))
    expect_equal(test_template$file_structure$paths$output_template_assets, file.path(test_template$file_structure$path$output, "clickme_assets", "TestTemplate"))
    expect_equal(test_template$file_structure$paths$output_shared_assets, file.path(test_template$file_structure$path$output, "clickme_assets"))

    expect_equal(test_template$file_structure$relative_path$template_assets, file.path("clickme_assets", "TestTemplate"))
    expect_equal(test_template$file_structure$relative_path$shared_assets, "clickme_assets")

    test_template <- TestTemplate$new(list(dir = "my_folder"))
    test_template$get_params()
    test_template$get_file_structure()
    expect_equal(test_template$file_structure$paths$output, "my_folder")
    expect_equal(test_template$file_structure$paths$output_file, file.path(test_template$file_structure$paths$output, test_template$file_structure$names$output_file))

    test_template <- TestTemplate$new(list(file = file.path("my_folder", "my_file1.html")))
    test_template$get_params()
    test_template$get_file_structure()
    expect_equal(test_template$file_structure$paths$output, "my_folder")
    expect_equal(test_template$file_structure$paths$output_file, file.path(test_template$file_structure$paths$output, test_template$file_structure$names$output_file))

    test_template <- TestTemplate$new(list(file = file.path("my_folder1", "my_file1.html"), dir = "my_folder2"))
    test_template$get_params()
    expect_warning(test_template$get_file_structure(), "The \"dir\" argument was ignored because the \"file\" argument was present: ")
    expect_equal(test_template$file_structure$paths$output, "my_folder1")
    expect_equal(test_template$file_structure$paths$output_file, file.path(test_template$file_structure$paths$output, test_template$file_structure$names$output_file))
    unlink("my_folder", recursive = TRUE)
    unlink("my_folder1", recursive = TRUE)
})

unlink(test_template_path, recursive = TRUE)

