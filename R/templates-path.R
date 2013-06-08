#' Set the templates path
#'
#' The templates path is the folder that contains the ractives that you have installed in your system. It will also contain the HTML visualization files that you generate. If you a using a local server to serve your HTML files, you should run it at the templates path. \code{set_templates_path} will set the templates path and generate the ractives folder below it. The ractives folder is where you should install existing ractives, or create new ones (see \code{?new_ractive})
#' @param path path to be used as root
#' @export
set_templates_path <- function(path) {
    if (!file.exists(path)) stop("Path doesn't exist: ", path)

    .clickme_env$templates_path <- path

    message("templates path set to: ", .clickme_env$templates_path)
}

#' Get the current templates path
#'
#' @export
get_templates_path <- function() {
    if (is.null(.clickme_env$templates_path)){
        clickme_templates_path <- getOption("clickme_templates_path")
        if (!is.null(clickme_templates_path)){
            if (!file.exists(clickme_templates_path)) stop("The path you used to set your clickme_templates_path option contains an invalid file path: \'", clickme_templates_path, "\'\n  You can change it directly, or use set_templates_path(\"/path/to/root/folder\")")

            .clickme_env$templates_path <- clickme_templates_path
        } else {
            separator <- paste0(rep("=", 70, collapse = ""))
            message(separator)
            message("No clickme_templates_path option found, using default templates path:")
            message("set_templates_path(\"", system.file("ractives", package = "clickme"), "\")")
            set_templates_path(system.file("ractives", package = "clickme"))
            message("\nThe templates path is the folder where your ractives live.\nSee the wiki for more info: bit.ly/clickme_wiki")
            message(separator)
        }

    }

    invisible(.clickme_env$templates_path)
}
