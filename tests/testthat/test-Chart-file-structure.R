context("Chart-file-structure")

test_chart_path <- file.path(getOption("clickme_templates_path"), "TestChart")
unlink(test_chart_path, recursive = TRUE)
TestChart <- setRefClass('TestChart', contains = "Chart", where=.GlobalEnv)
test_chart <- TestChart$new()
test_chart$get_params()

test_that("default paths are valid", {

    test_chart$get_unvalidated_file_structure()
    expect_error(test_chart$validate_file_structure(), gettextf("There is no template TestChart located in: %s", test_chart_path) )
    dir.create(test_chart_path)

    expect_error(test_chart$validate_file_structure(), gettextf("The TestChart template doesn't contain a template file in: %s", file.path(test_chart_path, "template", "template.Rmd")))
    dir.create(file.path(test_chart_path, "template"))
    file.create(file.path(test_chart_path, "template", "template.Rmd"))

    expect_error(test_chart$validate_file_structure(), gettextf("The TestChart template doesn't contain a configuration file in: %s", file.path(test_chart_path, "config.yml")))
    file.create(file.path(test_chart_path, "config.yml"))

    expect_error(test_chart$validate_file_structure(), gettextf("The TestChart template doesn't contain a translator file in: %s", file.path(test_chart_path, "translator", "TestChart.R")))
    dir.create(file.path(test_chart_path, "translator"))
    file.create(file.path(test_chart_path, "translator", "TestChart.R"))

    dir_path <- file.path(system.file("output", package = "clickme"), "output_test")
    test_chart <- TestChart$new(list(dir = dir_path))
    test_chart$get_params()
    test_chart$get_file_structure()
    expect_true(file.exists(dir_path))

    # folders
    expect_equal(test_chart$internal$file$paths$Template, test_chart_path)
    expect_equal(test_chart$internal$file$paths$template, file.path(test_chart_path, "template"))
    expect_equal(test_chart$internal$file$paths$translator, file.path(test_chart_path, "translator"))
    expect_equal(test_chart$internal$file$paths$tests, file.path(test_chart_path, "tests"))
    expect_equal(test_chart$internal$file$paths$template_assets, file.path(test_chart_path, "assets"))

    # files
    expect_equal(test_chart$internal$file$paths$template_file, file.path(test_chart$internal$file$paths$template, "template.Rmd"))
    expect_equal(test_chart$internal$file$paths$config_file, file.path(test_chart$internal$file$paths$Template, "config.yml"))
    expect_equal(test_chart$internal$file$paths$translator_file, file.path(test_chart$internal$file$paths$translator, "TestChart.R"))
    expect_equal(test_chart$internal$file$paths$translator_test_file, file.path(test_chart$internal$file$paths$tests, "test-TestChart.R"))

    test_chart <- TestChart$new(list(coffee = TRUE))
    test_chart$get_params()
    test_chart$get_unvalidated_file_structure()
    unlink(file.path(test_chart_path, "template", "template.Rmd"))
    expect_error(test_chart$validate_file_structure(), gettextf("The TestChart template doesn't contain a template file in: %s", test_chart$internal$file$paths$Template))

    file.create(file.path(test_chart$internal$file$paths$template, "template.coffee.Rmd"))
    expect_that(test_chart$validate_file_structure(), not(throws_error()))
    expect_equal(test_chart$internal$file$paths$template_coffee_file, file.path(test_chart$internal$file$paths$template, "template.coffee.Rmd"))

    file.create(file.path(test_chart$internal$file$paths$template, "template.Rmd"))

    unlink(dir_path, recursive = TRUE)
})


test_that("output file name is added", {
    expect_equal(test_chart$internal$file$names$output_file, "temp-TestChart.html")

    test_chart <- TestChart$new(list(file_path = file.path("my_folder", "my_file.html")))
    test_chart$get_params()
    test_chart$get_file_structure()
    expect_equal(test_chart$internal$file$names$output_file, "my_file.html")

    test_chart <- TestChart$new(list(file_path = file.path("my_folder", "my_file")))
    test_chart$get_params()
    test_chart$get_file_structure()
    expect_equal(test_chart$internal$file$names$output_file, "my_file.html")

    test_chart <- TestChart$new(list(file_path = "my_file.html"))
    test_chart$get_params()
    test_chart$get_file_structure()
    expect_equal(test_chart$internal$file$names$output_file, "my_file.html")

    test_chart <- TestChart$new(list(file_path = "my_file"))
    test_chart$get_params()
    test_chart$get_file_structure()
    expect_equal(test_chart$internal$file$names$output_file, "my_file.html")

    test_chart <- TestChart$new(list(file_path = file.path("my_folder", "my_file1.html"), file = "my_file2.html"))
    test_chart$get_params()
    expect_message(test_chart$get_file_structure(), "The \"file\" argument was ignored because the \"file_path\" argument was present: ")
    expect_equal(test_chart$internal$file$names$output_file, "my_file1.html")
})

test_that("output paths are added", {
    test_chart <- TestChart$new()
    test_chart$get_params()
    test_chart$get_file_structure()

    expect_equal(test_chart$internal$file$paths$output, system.file("output", package = "clickme"))
    expect_equal(test_chart$internal$file$paths$output_file, file.path(test_chart$internal$file$paths$output, test_chart$internal$file$names$output_file))

    expect_equal(test_chart$internal$file$paths$shared_assets, file.path(getOption("clickme_templates_path"), "..", "shared_assets"))
    expect_equal(test_chart$internal$file$paths$output_template_assets, file.path(test_chart$internal$file$path$output, "clickme_assets", "TestChart"))
    expect_equal(test_chart$internal$file$paths$output_shared_assets, file.path(test_chart$internal$file$path$output, "clickme_assets"))

    expect_equal(test_chart$internal$file$relative_path$template_assets, file.path("clickme_assets", "TestChart"))
    expect_equal(test_chart$internal$file$relative_path$shared_assets, "clickme_assets")

    test_chart <- TestChart$new(list(dir = "my_folder"))
    test_chart$get_params()
    test_chart$get_file_structure()
    expect_equal(test_chart$internal$file$paths$output, "my_folder")
    expect_equal(test_chart$internal$file$paths$output_file, file.path(test_chart$internal$file$paths$output, test_chart$internal$file$names$output_file))

    test_chart <- TestChart$new(list(file_path = file.path("my_folder", "my_file1.html")))
    test_chart$get_params()
    test_chart$get_file_structure()
    expect_equal(test_chart$internal$file$paths$output, "my_folder")
    expect_equal(test_chart$internal$file$paths$output_file, file.path(test_chart$internal$file$paths$output, test_chart$internal$file$names$output_file))

    test_chart <- TestChart$new(list(file_path = file.path("my_folder1", "my_file1.html"), dir = "my_folder2"))
    test_chart$get_params()
    expect_message(test_chart$get_file_structure(), "The \"dir\" argument was ignored because the \"file_path\" argument was present")
    expect_equal(test_chart$internal$file$paths$output, "my_folder1")
    expect_equal(test_chart$internal$file$paths$output_file, file.path(test_chart$internal$file$paths$output, test_chart$internal$file$names$output_file))
    unlink("my_folder", recursive = TRUE)
    unlink("my_folder1", recursive = TRUE)
})

unlink(test_chart_path, recursive = TRUE)

