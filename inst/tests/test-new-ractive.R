context("new_ractive")

test_that("root path is set before creating a new ractive", {
    .clickme_env$root_path <- NULL
    expect_error(new_ractive("tmp_ractive"), "Root path not set")
})

test_that("doesn't overwrite an existing ractive, unless specified", {
    set_root_path(system.file("examples", package="clickme"))
    ractive <- "tmp_ractive"
    cleanup_files(file.path(get_root_path(), ractive)) # to be sure it doesn't exist

    new_ractive(ractive)
    expect_error(new_ractive(ractive), "ractive already exists")
    new_ractive(ractive, overwrite = TRUE)
    expect_true(file.exists(file.path(get_root_path(), ractive)))

    cleanup_files(file.path(get_root_path(), ractive))
})

test_that("test names and paths are set when creating a new ractive", {
    set_root_path(system.file("examples", package="clickme"))
    ractive <- "tmp_ractive"
    cleanup_files(file.path(get_root_path(), ractive)) # to be sure it doesn't exist

    opts <- new_ractive(ractive)

    # expect_equal(opts$path$tests, file.path(opts$path$ractive, opts$name$tests))
    expect_equal(opts$path$translator_test_file, file.path(opts$path$tests, opts$name$translator_test_file))
    expect_equal(opts$path$run_tests_file, file.path(opts$path$tests, opts$name$run_tests_file))

    cleanup_files(file.path(get_root_path(), ractive))
})

test_that("creates a new blank ractive", {
    set_root_path(system.file("examples", package="clickme"))
    ractive <- "tmp_ractive"
    cleanup_files(file.path(get_root_path(), ractive)) # to be sure it doesn't exist

    opts <- new_ractive(ractive)

    # folders
    expect_true(file.exists(file.path(opts$path$data)))
    expect_true(file.exists(file.path(opts$path$external)))
    expect_true(file.exists(file.path(opts$path$template)))
    expect_true(file.exists(file.path(opts$path$tests)))

    # files
    expect_true(file.exists(file.path(opts$path$translator_file)))
    expect_true(file.exists(file.path(opts$path$template_config_file)))
    expect_true(file.exists(file.path(opts$path$template_file)))

    cleanup_files(file.path(get_root_path(), ractive))

})