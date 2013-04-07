#' Generate HTML style and script tags
#'
#' @param opts the options of the current template
#' @export
append_external <- function(opts){
    styles_and_scripts <- paste0(c(append_styles(opts), append_scripts(opts)), collapse="\n")
    styles_and_scripts
}

#' Generate HTML script tags
#'
#' @param opts the options of the current template
#' @export
append_scripts <- function(opts) {
    scripts <- paste(sapply(opts$template_config$scripts, function(script_path){
        if (!grepl("^http", script_path)){
            script_path <- file.path(opts$relative_path$external, script_path)
        }
        paste0("<script src=\"", script_path, "\"></script>")
    }), collapse="\n")

    scripts
}

#' Generate HTML style tags
#'
#' @param opts the options of the current template
#' @export
append_styles <- function(opts) {
    styles <- paste(sapply(opts$template_config$styles, function(style_path){
        if (!grepl("^http", style_path)){
            style_path <- file.path(opts$relative_path$external, style_path)
        }
        paste0("<link href=\"", style_path, "\" rel=\"stylesheet\">")
    }), collapse="\n")

    styles
}

#' Create a data file
#'
#' Creates a file in the ractive data directory
#'
#' @param opts the options of the current template
#' @param extension the extension of the file
#' @param sep the character used to separate fields in each line of the file ("," by default)
#' @param method function used to generate the file (".csv" uses "write.csv" by default, every other file extension uses "writeLines")
#' @param row_names show row names when using \code{write.csv}
#' @param relative_path boolean indicating if the path to the file should be relative or absolute
#' @param quote_escaped boolean indicating if the file name should be surrounded with escaped quotes.
#' @param ... arguments passed to the function specified by method
#' @export
create_data_file <- function(opts, extension, sep=",", method = NULL, row_names = FALSE, relative_path = TRUE, quote_escaped = TRUE, ...) {
    if (!grepl("^\\.", extension)) extension <- paste0(".", extension)

    data_file_name <- paste0(opts$data_name, extension)
    data_file_path <- file.path(opts$path$data, data_file_name)
    relative_data_file_path <- file.path(opts$relative_path$data, data_file_name)

    if ((is.null(method) && extension == ".csv") || (!is.null(method) && method == "write.csv")){
        write.csv(opts$data, file = data_file_path, row.names = row_names,...)
    } else {
        writeLines(text = opts$data, con = data_file_path, ...)
    }
    message("Created data file at: ", data_file_path)

    if (relative_path){
        path <- relative_data_file_path
    } else {
        path <- data_file_path
    }

    if (quote_escaped){
        path <- quote_escaped(path)
    }

    path
}

#' Read a ractive's CSV file
#'
#'
#'
#' @param ractive ractive name
#' @param file_name CSV file name
#' @export
read_ractive_csv <- function(ractive, file_name) {
    opts <- get_opts(ractive)
    data <- read.csv(file.path(opts$path$data, file_name))

    data
}

readContents <- function(path) {
    paste(readLines(path), collapse = "\n")
}

#' Inverse Value Matching
#'
#' Complement of \code{\%in\%}. Returns the elements of \code{a} that are not in \code{b}.
#' @usage a \%notin\% b
#' @param a a vector
#' @param b a vector
#' @export
#' @rdname notin
"%notin%" <- function(a, b) {
    !(a %in% b)
}

#' Set default value
#'
#' If a is not null, return a. Otherwise, return b.
#' @usage a \%||\% b
#' @param a an object
#' @param b an object
#' @export
#' @rdname nulldefault
#' @examples
#' a <- "a"
#' b <- "b"
#' d <- a %||% b # d == "a"
#' a <- NULL
#' d <- a %||% b # d == "b"
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

#' Surround with escaped quotes
#'
#' @param data object to surround with escaped quotes
#' @export
quote_escaped <- function(data) {
    paste0("\"", data, "\"")
}

#' Run a local server
#'
#' @param path path where server is started
#' @param port port used to start the server
#' @export
server <- function(path=get_root_path(), port=8888){
    system(paste0("cd ", path, "; python -m SimpleHTTPServer ", port))
    message("Server running at ", path)
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

#' Open an HTML file in the browser
#'
#' By default it will open \code{get_opts(ractive)$url}
#'
#' @param ractive ractive name
#' @param ... additional fields for \code{get_opts}
#' @export
open_html <- function(ractive, ...) {
    opts <- get_opts(ractive, ...)
    browseURL(opts$url)
}

open_all_html <- function(){
    for(ractive in plain_list_ractives()){
        open_html(ractive)
    }
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

#' Run ractive examples
#'
#'
#'
#' @param ractive name of ractive
#' @export
demo_ractive <- function(ractive) {
    opts <- get_opts(ractive)
    if (is.null(opts$template_config$demo)){
        message("The ", ractive, " ractive didn't provide a demo example.")
    } else {
        message("* Getting ready to run the following ", ractive, " demo:\n\n", opts$template_config$demo)
        cat("\nGo ahead? (y)es (n)o ")
        response <- readline()
        if (tolower(response) %in% c("yes", "y")) {
            message("* Running...")
            eval(parse(text = opts$template_config$demo))
        } else {
            message("Demo wasn't run")
        }
    }
}

#' Generates a JavaScript visualization using Vega
#'
#' @param data input data
#' @param spec Name of the vega spec file to use, it must match a file within \code{vega/data/spec/}
#' @param ... additional arguments for \code{clickme}
#' @export
clickme_vega <- function(data, spec, ...){
    dots <- list(...)

    if (is.null(dots$params)) {
        params <- list(spec = spec)
    } else {
        params <- dots$params
        dots$params <- NULL
        params$spec = spec
    }

    if (is.null(dots$data_name)){
        dots$data_name <- paste0("data_", spec)
    }
    data_name <- dots$data_name
    dots$data_name <- NULL

    if (is.null(dots$browse)){
        dots$browse <- interactive()
    }
    browse <- dots$browse
    dots$browse <- NULL

    if (length(dots) != 0){
        clickme(data, "vega", browse = browse, params = params, data_name = data_name, dots)
    } else {
        clickme(data, "vega", browse = browse, params = params, data_name = data_name)
    }
}


#' Test generated file
#'
#' Test that the path exists, and that the contents are as expected
#'
#' @param opts options
#' @param extension extension of the file
#' @param expected_data data that should be stored in the test file.
#' @param test_data_name value used on the \code{get_opts(..., data_name = test_data_name)} call. It is "test_data" by default.
#' @export
expect_correct_file <- function(opts, extension, expected_data = NULL, test_data_name = "test_data") {
    if (!grepl("^\\.", extension)) extension <- paste0(".", extension)

    expected_relative_path <- paste("\"", file.path(opts$relative_path$data, paste0(test_data_name, extension)), "\"")
    expected_path <- file.path(opts$path$data, paste0(test_data_name, extension))
    expect_true(file.exists(expected_path))
    if (!is.null(expected_data)){
        expect_equal(readContents(expected_path), expected_data)
    }
    unlink(expected_path)
}
