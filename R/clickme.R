#' When called with only the template, it sets the current template used by \code{cm}
#' When called with more than the template
#' @export
clickme <- function(template_name, ...){
    if (length(list(...)) == 0){
        options(clickme_current_template = template_name)
    } else {
        reload_translators()

        snake_case_template <- snake_case(template_name)
        camel_case_template <- camel_case(template_name)

        if (snake_case_template %notin% names(clickme_helper)){
            stop(gettextf("\n\n\tThe %s template is missing a helper function or is not installed in %s\n", camel_case_template, getOption("clickme_templates_path")))
        }
        clickme_helper[[snake_case_template]](...)
    }
}


#' @export
cm <- function(...){
    current_template <- getOption("clickme_current_template") %or% "points"
    clickme(current_template, ...)
}
