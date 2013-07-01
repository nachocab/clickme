#' @export
clickme <- function(template, ...){
    reload_templates()
    clickme_helper[[template]](...)
}
