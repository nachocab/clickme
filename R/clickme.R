#' When called with only the template, it sets the current template used by \code{cme}
#' When called with more than the template
#' @export
#' @include utils.R
clickme <- function(template_name, ...){
    if (missing(template_name))
        return(getOption("clickme_current_template"))

    if (is.null(template_name)){
        options(clickme_current_template = NULL)
        return()
    }

    if (!is.character(template_name))
        template_name <- as.character(substitute(template_name))

    if (length(list(...)) == 0){
        template_path <- file.path(getOption("clickme_templates_path"), camel_case(template_name))
        if (!file.exists(template_path)){
            stop(sprintf("\n\n\tThe %s template is not installed in path %s\n", template_name, template_path))
        }
        options(clickme_current_template = template_name)
    } else {
        reload_translators()

        snake_case_template <- snake_case(template_name)
        camel_case_template <- camel_case(template_name)

        if (snake_case_template %notin% names(clickme_helper)){
            stop(sprintf("\n\n\tThe %s template is missing a helper function or is not installed in %s\n", camel_case_template, getOption("clickme_templates_path")))
        }
        result <- clickme_helper[[snake_case_template]](...)

        if (demo_mode()){
            result$iframe()$hide()
        } else {
            result
        }
    }
}


#' @export
cme <- function(...){
    current_template <- getOption("clickme_current_template") %or% "points"
    clickme(current_template, ...)
}
