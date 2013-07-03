context("new template")

test_that("doesn't overwrite an existing template, unless specified", {
    new_template("TestChart")
    expect_error(new_template("TestChart"), "template already exists")

    new_template("TestChart", overwrite = TRUE)
    expect_true(file.exists(file.path(getOption("clickme_templates_path"), "TestChart")))

})
unlink(file.path(getOption("clickme_templates_path"), "TestChart"), recursive = TRUE)

test_that("creates a new blank template", {
    test_chart <- new_template("TestChart")

    # folders
    expect_true(file.exists(file.path(test_chart$file_structure$paths$Template)))
    expect_true(file.exists(file.path(test_chart$file_structure$paths$template_assets)))

    # files
    expect_true(file.exists(file.path(test_chart$file_structure$paths$config_file)))
    expect_true(file.exists(file.path(test_chart$file_structure$paths$template_file)))
    expect_true(file.exists(file.path(test_chart$file_structure$paths$translator_file)))
    expect_true(file.exists(file.path(test_chart$file_structure$paths$translator_test_file)))

})
unlink(file.path(getOption("clickme_templates_path"), "TestChart"), recursive = TRUE)