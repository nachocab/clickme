#' Set the root path
#'
#' clickme will use this path as the root for all its operations, like generating visualizations.
#' It should contain the templates folder.
#' @param path path to be used as root
#' @export
set_root_path <- function(path = getwd()) {
    if (!file.exists(path)) stop("Path doesn't exist: ", path)
    .clickme_env$root_path <- path

    message("root_path set to: ", .clickme_env$root_path)
}
