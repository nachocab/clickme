#' @export
clickme <- function(template, ...){
    reload_translators()
    clickme_helper[[template]](...)
}
