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

#' @export
test_translator <- function(ractive){
    library("testthat")
    source(file.path("..", "template", "translator.R"))
    test_file(opts$path$test_translator)
}