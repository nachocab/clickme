context("Template-blank")

template <- "temp_template"

test_that("doesn't overwrite an existing template, unless specified", {
    unlink(file.path(getOption("clickme_templates_path"), template), recursive = TRUE) # to be sure it doesn't exist

    new_template(template)
    expect_error(new_template(template), "template already exists")
    new_template(template, overwrite = TRUE)
    expect_true(file.exists(file.path(getOption("clickme_templates_path"), template)))

    unlink(file.path(getOption("clickme_templates_path"), template), recursive = TRUE)
})

test_that("creates a new blank template", {
    unlink(file.path(getOption("clickme_templates_path"), template), recursive = TRUE) # to be sure it doesn't exist

    opts <- new_template(template)

    # folders
    expect_true(file.exists(file.path(file_structure$paths$template)))
    expect_true(file.exists(file.path(file_structure$paths$template_assets)))

    # files
    expect_true(file.exists(file.path(file_structure$paths$config_file)))
    expect_true(file.exists(file.path(file_structure$paths$template_file)))
    expect_true(file.exists(file.path(file_structure$paths$translator_file)))
    expect_true(file.exists(file.path(file_structure$paths$translator_test_file)))

    unlink(file.path(getOption("clickme_templates_path"), template), recursive = TRUE)
})