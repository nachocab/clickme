#' Translate the data object to the format expected by template.Rmd
#'
#' It returns the translated data object.
#'
#' @param data input data object
#' @param opts options returned by get_opts
# I'm not sure if opts should be passed as a parameter or not. A translator might need to access template_config
clickme_translate <- function(data, opts) {
    write.table(data, file = file.path(opts$path$data_file), sep = ",", quote=FALSE, row.names=FALSE, col.names=TRUE)
    path <- clickme:::clickme_quote(file.path(opts$relative_path$data, opts$name$data_file))
    path
}
