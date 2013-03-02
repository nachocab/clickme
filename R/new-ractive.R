#' Creates the folder structure for a ractive
#'
#'
new_ractive <- function(ractive) {
    opts <- add_ractive_opts(ractive)
    if (is.null(get_root_path())) stop("Root path not set, use set_root_path(\"path/to/root\")")

    if (file.exists(opts$path$ractive)) stop("ractive already exists: ", opts$path$ractive)

    sapply(c(opts$path$ractive,
             opts$path$external,
             opts$path$template,
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