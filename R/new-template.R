#' Creates the folder structure for a template
#'
#'
new_template <- function(template_id) {
    if (is.null(.clickme_env$path)) clickme_path()

    template_id_path <- file.path(.clickme_env$path, .clickme_env$templates_dir_name, template_id)
    if (file.exists(template_id_path)) {
        stop("Template already exists: ", template_id_path)
    }

    sapply(c("",
             .clickme_env$translator_dir_name,
            .clickme_env$scripts_dir_name,
            .clickme_env$styles_dir_name), function(dir){
        path <- file.path(template_id_path, dir)
        dir.create(path)
        message("Created directory: ", path)
    })

    sapply(c(.clickme_env$template_file_name,
             .clickme_env$config_file_name,
             file.path(.clickme_env$translator_dir_name, .clickme_env$translator_file_name)), function(file){
        path <- file.path(template_id_path, file)
        file.create(path)
        message("Created file: ", path)
    })

    return()
}