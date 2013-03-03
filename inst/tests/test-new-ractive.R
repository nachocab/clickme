context("new_ractive")

test_that("root path is set before creating a new ractive", {
    .clickme_env$root_path <- NULL
    expect_error(new_ractive("tmp_ractive"), "Root path not set")
})

test_that("doesn't overwrite an existing ractive", {
    set_root_path(system.file("examples", package="clickme"))
    expect_error(new_ractive("force_directed"), "The force_directed ractive already exists")
})

test_that("creates a new blank ractive", {
    set_root_path(system.file("examples", package="clickme"))
    ractive <- "tmp_ractive"

    cleanup_files(file.path(system.file("examples", package="clickme"), .clickme_env$ractives_dir_name, ractive)) # to be sure it doesn't exist

    new_ractive(ractive)
    opts <- add_ractive_opts(ractive)

    # folders
    expect_true(file.exists(file.path(opts$path$data)))
    expect_true(file.exists(file.path(opts$path$external)))
    expect_true(file.exists(file.path(opts$path$template)))
    expect_true(file.exists(file.path(opts$path$tests)))

    # files
    expect_true(file.exists(file.path(opts$path$translator_file)))
    expect_true(file.exists(file.path(opts$path$template_config_file)))
    expect_true(file.exists(file.path(opts$path$template_file)))

    cleanup_files(file.path(system.file("examples", package="clickme"), .clickme_env$ractives_dir_name, ractive))

})