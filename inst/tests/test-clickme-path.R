context("clickme_path")

test_that("sets the default folder structure", {

    dirs <- c("data", "templates")
    sapply(dirs, function(dir){
        unlink(file.path(getwd(), dir), recursive=TRUE)
    })

    clickme_path()
    expect_equal(getwd(), .clickme_env$path)
    sapply(dirs, function(dir){
        expect_true(file.exists(file.path(.clickme_env$path, dir)))
    })

    sapply(dirs, function(dir){
        unlink(file.path(getwd(), "tmp", dir), recursive=TRUE)
    })

    clickme_path(file.path(getwd(), "tmp"))
    expect_equal(file.path(getwd(), "tmp"), .clickme_env$path)
    sapply(dirs, function(dir){
        expect_true(file.exists(file.path(.clickme_env$path, dir)))
    })
    unlink(.clickme_env$path, recursive = TRUE)
})

context("create_template")

test_that("creates a blank template", {

    clickme_path()
    create_template("tmp_template")
    files <- c("data", "templates", "template.Rmd", "config.yml")
    sapply(files, function(file){
        expect_true(file.exists(file.path(.clickme_env$path, "templates", "tmp_template", file)))
    })

})