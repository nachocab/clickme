#' Set the root path
#'
#' clickme will use this path as the root for all its operations, like generating visualizations.
#' It should contain the templates folder. The server should be run from here.
#' @param path path to be used as root
#' @export
set_root_path <- function(path) {
    if (!file.exists(path)) stop("Path doesn't exist: ", path)

    if (!file.exists(file.path(path, .clickme_env$templates_dir_name))) dir.create(file.path(path, .clickme_env$templates_dir_name))

    .clickme_env$root_path <- path

    message("root_path set to: ", get_root_path())
}

get_root_path <- function() {
    .clickme_env$root_path
}
