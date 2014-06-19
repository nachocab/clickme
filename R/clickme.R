#' When called with only the template, it sets the current template used by \code{cme}
#' When called with more than the template
#' @export
#' @include utils.R
clickme <- function(template, ...){

    if (missing(template))
        template <- getOption("clickme_current_template")

    if (is.null(template)){
        options(clickme_current_template = NULL)
        return()
    }
    # Let's determine what template to use
    if (!(is.character(template) && length(template) == 1)) {
        x <- template
        template <- getOption("clickme_current_template") %or%
                         getOption("clickme_default_template") %or%
                         "points"
        options(clickme_current_template = template)
        return(clickme(template, x, ...))
    }

    options(clickme_current_template = template)
    if (length(list(...)) == 0){
        template_path <- file.path(getOption("clickme_templates_path"), camel_case(template))
        if (!file.exists(template_path)){
            stop(sprintf("\n\tThe %s template is not installed in path %s\n", template, template_path), call. = FALSE)
        }
        options(clickme_current_template = template)
    } else {
        reload_translators()

        snake_case_template <- snake_case(template)
        camel_case_template <- camel_case(template)

        if (snake_case_template %notin% names(clickme_helper)){
            stop(sprintf("\n\tThe %s template is missing a helper function or is not installed in %s\n", camel_case_template, getOption("clickme_templates_path")), call. = FALSE)
        }
        result <- clickme_helper[[snake_case_template]](...)

        if (demo_mode()){
            result$iframe()$hide()
        } else {
            if (is.null(getOption("clickme_hide")) || !getOption("clickme_hide")){
                result
            } else {
                invisible(result)
            }
        }
    }
}

