context("clickme_path")

test_that("sets the default folder structure", {

    dirs <- c(.clickme_env$data_dir_name, .clickme_env$templates_dir_name)

    cleanup_files(getwd(), dirs)
    clickme_path()
    expect_equal(getwd(), .clickme_env$path)
    sapply(dirs, function(dir){
        expect_true(file.exists(file.path(.clickme_env$path, dir)))
    })
    cleanup_files(.clickme_env$path, dirs)


    cleanup_files(dirs, file.path(getwd(), "tmp"))
    clickme_path(file.path(getwd(), "tmp"))
    expect_equal(file.path(getwd(), "tmp"), .clickme_env$path)
    sapply(dirs, function(dir){
        expect_true(file.exists(file.path(.clickme_env$path, dir)))
    })
    cleanup_files(.clickme_env$path)
})

