#' Creates the folder structure for a template
#'
#' clickme_path()
#'   |- template_id
#'      |- scripts
#'      |- styles
#'      |- template.Rmd
#'      |- config.yml
create_template <- function(template_id) {
    if (is.null(.clickme_env$path)) clickme_path()

    dirs <-  c("", "scripts", "styles")
    sapply(dirs, function(dir){
        path <- file.path(.clickme_env$path, "templates", template_id, dir)
        dir.create(path)
        message("Created directory: ", path)
    })

    files <- c("template.Rmd", "config.yml")
    sapply(files, function(file){
        path <- file.path(.clickme_env$path, "templates", template_id, file)
        file.create(path)
        message("Created file: ", path)
    })
}