context("new_template")

test_that("creates a blank template", {

    clickme_path()
    template_id <- "tmp_template"
    dirs <- c(.clickme_env$template_file_name, .clickme_env$config_file_name)
    cleanup_files(file.path(.clickme_env$path, template_id), dirs) # make sure they were not created previously

    new_template(template_id)
    sapply(dirs, function(file){
        expect_true(file.exists(file.path(.clickme_env$path, .clickme_env$templates_dir_name, template_id, file)))
    })
    cleanup_files(file.path(.clickme_env$path), c(.clickme_env$templates_dir_name, .clickme_env$data_dir_name))

})

test_that("raises error if using an existing template_id", {

    clickme_path()
    template_id <- "tmp_template"
    dirs <- c(.clickme_env$template_file_name, .clickme_env$config_file_name)
    cleanup_files(file.path(.clickme_env$path, template_id), dirs) # make sure they were not created previously

    new_template(template_id)
    expect_error(new_template(template_id))

    cleanup_files(file.path(.clickme_env$path), c(.clickme_env$templates_dir_name, .clickme_env$data_dir_name))
})