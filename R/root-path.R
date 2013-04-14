#' Set the root path
#'
#' The root path is the folder that contains the ractives that you have installed in your system. It will also contain the HTML visualization files that you generate. If you a using a local server to serve your HTML files, you should run it at the root path. \code{set_root_path} will set the root path and generate the ractives folder below it. The ractives folder is where you should install existing ractives, or create new ones (see \code{?new_ractive})
#' @param path path to be used as root
#' @export
set_root_path <- function(path) {
    if (!file.exists(path)) stop("Path doesn't exist: ", path)

    .clickme_env$root_path <- path

    message("Root path set to: ", .clickme_env$root_path)
}

#' Get the current root path
#'
#' @export
get_root_path <- function() {
    if (is.null(.clickme_env$root_path)){
        clickme_root_path <- getOption("clickme_root_path")
        if (!is.null(clickme_root_path)){
            if (!file.exists(clickme_root_path)) stop("The path you used to set your clickme_root_path option contains an invalid file path: \'", clickme_root_path, "\'\n  You can change it directly, or use set_root_path(\"/path/to/root/folder\")")

            .clickme_env$root_path <- clickme_root_path
        } else {
            separator <- paste0(rep("=", 70, collapse = ""))
            message(separator)
            message("No clickme_root_path option found, using default root path:")
            message("set_root_path(\"", system.file("examples", package = "clickme"), "\")")
            set_root_path(system.file("examples", package = "clickme"))
            message("\nThe root path is the folder where your ractives live.\nSee the wiki for more info: bit.ly/clickme_wiki\n")
            message(separator)
        }

    }

    invisible(.clickme_env$root_path)
}
