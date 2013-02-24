#' Creates the folder structure for a template
#'
new_template <- function(template_id) {
    if (is.null(.clickme_env$path)) clickme_path()

    sapply(c("", .clickme_env$scripts_dir_name, .clickme_env$styles_dir_name), function(dir){
        path <- file.path(.clickme_env$path, .clickme_env$templates_dir_name, template_id, dir)
        dir.create(path)
        message("Created directory: ", path)
    })

    sapply(c(.clickme_env$template_file_name, .clickme_env$config_file_name), function(file){
        path <- file.path(.clickme_env$path, .clickme_env$templates_dir_name, template_id, file)
        file.create(path)
        message("Created file: ", path)
    })
}