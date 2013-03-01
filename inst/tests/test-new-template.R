context("new_template")

test_that("root path is set before creating a new template", {
    .clickme_env$root_path <- NULL
    expect_error(new_template("tmp_template"))
})

test_that("doesn't overwrite an existing template", {
    expect_error(new_template("force_directed_local"))
})

test_that("creates a new blank template", {
    set_root_path(system.file("demo", package="clickme"))
    template_id <- "tmp_template"

    cleanup_files(file.path(system.file("demo", package="clickme"), .clickme_env$templates_dir_name, template_id)) # to be sure it doesn't exist

    new_template(template_id)
    opts <- add_template_opts(template_id)
    expect_true(file.exists(file.path(opts$path$scripts)))
    expect_true(file.exists(file.path(opts$path$styles)))
    expect_true(file.exists(file.path(opts$path$data)))
    expect_true(file.exists(file.path(opts$path$translator_file)))
    expect_true(file.exists(file.path(opts$path$config_file)))
    expect_true(file.exists(file.path(opts$path$template_file)))

    cleanup_files(file.path(system.file("demo", package="clickme"), .clickme_env$templates_dir_name, template_id))

})