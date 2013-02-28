#' Set the path that contains templates and visualizations
#'
#'
clickme_path <- function(path=getwd()) {
    .clickme_env$path <- path

    dirs <-  c("", "data", "templates")
    sapply(dirs, function(dir){
        path <- file.path(.clickme_env$path, dir)
        if (!file.exists(path)) dir.create(path)
    })

    message("clickme_path set to: ", .clickme_env$path)
}