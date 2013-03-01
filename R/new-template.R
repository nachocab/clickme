#' Creates the folder structure for a template
#'
#'
new_template <- function(template_id) {
    if (is.null(.clickme_env$path)) set_root_path()

    path$template_id <- file.path(.clickme_env$path, .clickme_env$name$templates, template_id)
    if (file.exists(path$template_id)) {
        stop("Template already exists: ", path$template_id)
    }

    sapply(c("",
             .clickme_env$name$translator,
            .clickme_env$name$scripts,
            .clickme_env$name$styles), function(dir){
        path <- file.path(path$template_id, dir)
        dir.create(path)
        message("Created directory: ", path)
    })

    sapply(c(.clickme_env$name$template_file,
             .clickme_env$name$config_file,
             file.path(.clickme_env$name$translator, .clickme_env$name$translator_file)), function(file){
        path <- file.path(path$template_id, file)
        file.create(path)
        message("Created file: ", path)
    })

    return()
}