context("new template")

test_that("doesn't overwrite an existing template, unless specified", {
    new_template("TestTemplate")
    expect_error(new_template("TestTemplate"), "template already exists")

    new_template("TestTemplate", overwrite = TRUE)
    expect_true(file.exists(file.path(getOption("clickme_templates_path"), "TestTemplate")))

})
unlink(file.path(getOption("clickme_templates_path"), "TestTemplate"), recursive = TRUE)

test_that("creates a new blank template", {
    test_template <- new_template("TestTemplate")

    # folders
    expect_true(file.exists(file.path(test_template$file_structure$paths$template)))
    expect_true(file.exists(file.path(test_template$file_structure$paths$template_assets)))

    # files
    expect_true(file.exists(file.path(test_template$file_structure$paths$config_file)))
    expect_true(file.exists(file.path(test_template$file_structure$paths$template_file)))
    expect_true(file.exists(file.path(test_template$file_structure$paths$translator_file)))
    expect_true(file.exists(file.path(test_template$file_structure$paths$translator_test_file)))

})
unlink(file.path(getOption("clickme_templates_path"), "TestTemplate"), recursive = TRUE)