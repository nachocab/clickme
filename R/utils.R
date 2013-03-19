# @keyword internal
"%notin%" <- function(x,y) !(x %in% y)

# @keyword internal
# @name nulldefault-infix
"%||%" <- function(a, b) {
  if (!is.null(a)) a else b
}

source_dir <- function(path){
    sapply(list.files(path), function(file){
        source(file.path(path, file))
    })
}

is.installed <- function(package) {
    is.element(package, installed.packages()[,1])
}

clickme_quote <- function(data) {
    paste0("\"", data, "\"")
}

#' Run a local server
#'
#' @export
server <- function(path=get_root_path(), port=8888){
    system(paste0("pushd ", path, "; python -m SimpleHTTPServer", port, "; popd"))
}

#' Test the translator of a given ractive
#'
#' @param ractive name of ractive
#' @export
test_translator <- function(ractive){
    opts <- get_opts(ractive)

    if (file.exists(opts$path$translator_test_file)){
        library("testthat")
        source(opts$path$translator_file)
        test_file(opts$path$translator_test_file)
    } else {
        stop(paste0("There is no test translator file at this location: ", opts$path$translator_test_file, "\nYou might have to create it or call set_root_path()"))
    }
}

#' return a matrix with random values
#'
#' @export
mat <- function(elements=NULL, num_elements=nrow*ncol, nrow=5, ncol=2, scale_by=100, rownames=NULL, colnames=NULL){
    if (is.null(elements)){
        elements <- runif(num_elements) * scale_by
    }
    if (!is.null(ncol)){
        mat <- matrix(elements, ncol=ncol, byrow=T)
    } else {
        mat <- matrix(elements, nrow=nrow, byrow=T)
    }

    if (!is.null(rownames)) rownames(mat) <- rownames
    if (!is.null(colnames)) colnames(mat) <- colnames

    mat
}

#' Show which ractives are available
#'
#' @export
list_ractives <- function() {
    message("Available ractives at: ", get_root_path())
    write(plain_list_ractives(), "")
}

plain_list_ractives <- function() {
    basename(list.dirs(get_root_path(), recursive=F))
}

#' Get information about a ractive
#'
#' @param ractive ractive name
#' @export
ractive_info <- function(ractive){
    opts <- get_opts(ractive)

    if (!is.null(opts$template_config$purpose)){
        message("Purpose:")
        write(opts$template_config$purpose, "")
    }

    if (!is.null(opts$template_config$valid_names)){
        message("Valid names:")
        write(opts$template_config$valid_names, "")
        message("")
    }

    if (!is.null(opts$template_config$name_comments)){
        message("Name comments:")
        write(opts$template_config$name_comments, "")
    }

    if (!is.null(opts$template_config$original)){
        message("Original version: ", opts$template_config$original)
    }
}