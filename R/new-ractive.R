#' Creates a new ractive
#'
#' This creates the folder structure with the files that a ractive needs.
#' @param ractive_name
#' @param overwrite
#' @export
new_ractive <- function(ractive_name, overwrite = FALSE) {
    opts <- add_ractive_opts(ractive_name)

    if (overwrite){
        cleanup_files(file.path(get_root_path(), ractive_name))
    } else {
        if (file.exists(opts$path$ractive)) stop("The ", opts$name$ractive, " ractive already exists: ", opts$path$ractive)
    }

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
             opts$path$translator_test_file,
             opts$path$translator_file), function(path){
                file.create(path)
                message("Created file: ", path)
             })

    writeLines("valid_names:

scripts:

styles:

", opts$path$template_config_file)

    writeLines("#' Translate the data object to the format expected by template.Rmd
#'
#' It returns the translated data object.
#'
#' @param data input data object
#' @param opts options returned by get_opts
translate <- function(data, opts) {
    data
}", opts$path$translator_file)

    writeLines("context(\"translate\")

test_that(\"dataframes are translated to the format expected by the template\", {

})", opts$path$translator_test_file)

}