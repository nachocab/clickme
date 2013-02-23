context("clickme_path")

test_that("sets the default folder structure", {

    dirs <- c("data", "templates")

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

context("create_template")

test_that("creates a blank template", {

    clickme_path()

    files <- c("template.Rmd", "config.yml")
    cleanup_files(file.path(.clickme_env$path, "tmp_template"), files)
    create_template("tmp_template")
    sapply(files, function(file){
        expect_true(file.exists(file.path(.clickme_env$path, "templates", "tmp_template", file)))
    })
    cleanup_files(file.path(.clickme_env$path), c("templates", "data"))

})