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
#' @param path path where server is started
#' @param port port used to start the server
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


#' @import stringr
titleize <- function(str){
    str <- str_replace(str,"_"," ")
    words_in_str <- strsplit(str, " ")[[1]]
    title <- paste0(toupper(substring(words_in_str, 1,1)), substring(words_in_str, 2), collapse=" ")
    names(title) <- NULL
    title
}

#' Get information about a ractive
#'
#' @param ractive ractive name
#' @param fields any of the fields in template_config.yml
#' @export
show_ractive <- function(ractive, fields = NULL){

    opts <- get_opts(ractive)

    fields <- fields %||% names(opts$template_config)

    message("Ractive")
    cat(ractive, "\n\n")

    for (field in fields){
        if (!is.null(opts$template[[field]])){
            if (field == "default_parameters") {
                if (length(opts$template_config$default_parameters) > 0){
                    message(paste0(titleize(field)))
                    cat(paste0(paste0(names(opts$template_config$default_parameters), ": ", opts$template_config$default_parameters), collapse="\n"), "\n\n")
                }
            } else {
                message(paste0(titleize(field)))
                cat(paste0(opts$template_config[[field]], collapse="\n"), "\n")
            }

            if (field %notin% c("info", "name_comments", "default_parameters")){
                cat("\n")
            }
        }
    }

    cat("\n")
}