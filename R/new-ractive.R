#' Creates a new ractive
#'
#' This creates the folder structure with the files that a ractive needs.
#' @export
new_ractive <- function(ractive_name) {
    if (is.null(get_root_path())) stop("Root path not set, see ?set_root_path")

    opts <- add_ractive_opts(ractive_name)
    if (file.exists(opts$path$ractive)) stop("The ", opts$name$ractive, " ractive already exists: ", opts$path$ractive)

    opts$name$tests <- "tests"

    opts$name$translator_test_file <- "test-translator.R"
    opts$name$run_tests_file <- "run-tests.R"

    opts$path$tests <- file.path(opts$path$ractive, opts$name$tests)

    opts$path$translator_test_file <- file.path(opts$path$tests, opts$name$translator_test_file)
    opts$path$run_tests_file <- file.path(opts$path$tests, opts$name$run_tests_file)


    message("Adding new ractive: ", opts$name$ractive)
    sapply(c(opts$path$ractive,
             opts$path$external,
             opts$path$template,
             opts$path$tests,
             opts$path$data), function(path){
                dir.create(path)
                message("Created directory: ", path)
             })

    sapply(c(opts$path$template_file,
             opts$path$template_config_file,
             opts$path$run_tests_file,
             opts$path$translator_test_file,
             opts$path$translator_file), function(path){
                file.create(path)
                message("Created file: ", path)
             })

    writeLines("#' Translate the data object to the format expected by template.Rmd
#'
#' It returns the translated data object.
#'
#' @param data input data object
#' @param opts options returned by get_opts
clickme_translate <- function(data, opts) {
    data
}", opts$path$translator_file)

    writeLines("context(\"clickme_translate\")

test_that(\"dataframes are translated to the format expected by the ractive\", {

})", opts$path$translator_test_file)

    writeLines("library(\"testthat\")

# setwd(\"path/to/tests\")
source(file.path(\"..\", \"template\", \"translator.R\"))
test_file(\"test-translator.R\")
", opts$path$run_tests_file)

    invisible(opts)
}