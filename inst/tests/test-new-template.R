context("new_template")

test_that("creates a blank template", {

    set_root_path()
    template_id <- "tmp_template"
    dirs <- c(.clickme_env$name$template_file, .clickme_env$name$config_file)
    cleanup_files(path=file.path(.clickme_env$root_path, template_id), dirs) # make sure they were not created previously

    new_template(template_id)
    sapply(dirs, function(file){
        expect_true(file.exists(file.path(.clickme_env$root_path, .clickme_env$name$templates, template_id, file)))
    })
    cleanup_files(path=file.path(.clickme_env$root_path), c(.clickme_env$name$templates, .clickme_env$name$data))

})

test_that("raises error if using an existing template_id", {

    set_root_path()
    template_id <- "tmp_template"
    dirs <- c(.clickme_env$name$template_file, .clickme_env$name$config_file)
    cleanup_files(path=file.path(.clickme_env$root_path, template_id), dirs) # make sure they were not created previously

    new_template(template_id)
    expect_error(new_template(template_id))

    cleanup_files(path=file.path(.clickme_env$root_path), c(.clickme_env$name$templates, .clickme_env$name$data))
})