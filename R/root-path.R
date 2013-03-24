#' Set the root path
#'
#' The root path is the folder that contains the ractives that you have installed in your system. It will also contain the HTML visualization files that you generate. If you a using a local server to serve your HTML files, you should run it at the root path. \code{set_root_path} will set the root path and generate the ractives folder below it. The ractives folder is where you should install existing ractives, or create new ones (see \code{?new_ractive})
#' @param path path to be used as root
#' @export
set_root_path <- function(path) {
    if (!file.exists(path)) stop("Path doesn't exist: \'", path, "\'")

    .clickme_env$root_path <- path

    message("Root path set to: ", .clickme_env$root_path)
}

#' Get the current root path
#'
#' @export
get_root_path <- function() {
    if (is.null(.clickme_env$root_path)){
        if (exists("CLICKME_ROOT_PATH") && !is.null(CLICKME_ROOT_PATH)){
            if (!file.exists(CLICKME_ROOT_PATH)) stop("Your CLICKME_ROOT_PATH variable contains an invalid file path: \'", CLICKME_ROOT_PATH, "\'\n  You can change it directly, or use set_root_path(\"valid/path/to/root/folder\")")

            .clickme_env$root_path <- CLICKME_ROOT_PATH
        } else {
            message("No CLICKME_ROOT_PATH variable found, using default root path.")
            set_root_path(system.file("examples", package = "clickme"))
        }

    }
    .clickme_env$root_path
}
