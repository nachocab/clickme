#' Set the root path
#'
#' The root path is the folder that contains the ractives that you have installed in your system. It will also contain the HTML visualization files that you generate. If you a using a local server to serve your HTML files, you should run it at the root path. \code{set_root_path} will set the root path and generate the ractives folder below it. The ractives folder is where you should install existing ractives, or create new ones (see \code{?new_ractive})
#' @param path path to be used as root
#' @export
set_root_path <- function(root_path) {
    if (!file.exists(root_path)) stop("Path doesn't exist: \'", root_path, "\'")

    .clickme_env$root_path <- root_path

    message("Root path set to: ", .clickme_env$root_path)
}

#' @export
get_root_path <- function() {
    .clickme_env$root_path
}
