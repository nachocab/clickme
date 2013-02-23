#' Set the path that contains templates and visualizations
clickme_path <- function(path=getwd()) {
    .clickme_env$path <- path

    dirs <-  c("", "data", "templates")
    sapply(dirs, function(dir){
        path <- file.path(.clickme_env$path, dir)
        if (!file.exists(path)) dir.create(path)
    })

    message("clickme_path set to: ", .clickme_env$path)
}


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