context("new template")

test_that("doesn't replace an existing template, unless specified", {
    new_template("TestChart")
    expect_error(new_template("TestChart"), "template already exists")

    new_template("TestChart", replace = TRUE)
    expect_true(file.exists(file.path(getOption("clickme_templates_path"), "TestChart")))

})
unlink(file.path(getOption("clickme_templates_path"), "TestChart"), recursive = TRUE)

test_that("creates a new template", {
    test_chart <- new_template("TestChart")

    # folders
    expect_true(file.exists(file.path(test_chart$internal$file$paths$Template)))
    expect_true(file.exists(file.path(test_chart$internal$file$paths$template_assets)))

    # files
    expect_true(file.exists(file.path(test_chart$internal$file$paths$config_file)))
    expect_true(file.exists(file.path(test_chart$internal$file$paths$template_file)))
    expect_true(file.exists(file.path(test_chart$internal$file$paths$translator_file)))
    expect_true(file.exists(file.path(test_chart$internal$file$paths$translator_test_file)))

    expect_that(clickme("test_chart", 1:10)$hide(), not(throws_error()))
})
unlink(file.path(getOption("clickme_templates_path"), "TestChart"), recursive = TRUE)