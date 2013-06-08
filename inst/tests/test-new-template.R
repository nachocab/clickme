context("new_template")

template <- "tmp_template"

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

    new_template(template)
    opts <- get_opts(template)

    # folders
    expect_true(file.exists(file.path(opts$path$data)))
    expect_true(file.exists(file.path(opts$path$template_assets)))
    expect_true(file.exists(file.path(opts$path$template)))

    # files
    expect_true(file.exists(file.path(opts$path$translator_file)))
    expect_true(file.exists(file.path(opts$path$config_file)))
    expect_true(file.exists(file.path(opts$path$template_file)))

    unlink(file.path(getOption("clickme_templates_path"), template), recursive = TRUE)
})