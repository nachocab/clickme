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
    expect_true(file.exists(file.path(test_chart$file_structure$paths$Template)))
    expect_true(file.exists(file.path(test_chart$file_structure$paths$template_assets)))

    # files
    expect_true(file.exists(file.path(test_chart$file_structure$paths$config_file)))
    expect_true(file.exists(file.path(test_chart$file_structure$paths$template_file)))
    expect_true(file.exists(file.path(test_chart$file_structure$paths$translator_file)))
    expect_true(file.exists(file.path(test_chart$file_structure$paths$translator_test_file)))

    expect_that(clickme("test_chart", 1:10, action = FALSE), not(throws_error()))

    capture.output(t <- test_template("TestChart"))
    expect_false(t$failed)

})
unlink(file.path(getOption("clickme_templates_path"), "TestChart"), recursive = TRUE)