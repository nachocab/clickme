#' Creates the folder structure for a template
#'
#'
new_template <- function(template_id) {
    opts <- add_template_opts(template_id)
    if (is.null(get_root_path())) stop("Root path not set, use set_root_path(\"path/to/root\")")

    if (file.exists(opts$path$template_id)) stop("Template already exists: ", opts$path$template_id)

    sapply(c(opts$path$template_id,
             opts$path$translator,
             opts$path$scripts,
             opts$path$styles,
             opts$path$data), function(path){
                dir.create(path)
                message("Created directory: ", path)
             })

    sapply(c(opts$path$template_file,
             opts$path$config_file,
             opts$path$translator_file), function(path){
                file.create(path)
                message("Created file: ", path)
             })

    invisible()
}