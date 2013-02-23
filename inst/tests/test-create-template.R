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