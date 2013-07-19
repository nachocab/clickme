#' @export
clickme <- function(template, ...){
    reload_translators()

    template <- as.character(substitute(template))

    snake_case_template <- snake_case(template)
    camel_case_template <- camel_case(template)

    if (snake_case_template %notin% names(clickme_helper)){
        stop(gettextf("\n\n\tThe %s template is missing a helper function or is not installed in %s\n", camel_case_template, getOption("clickme_templates_path")))
    }
    clickme_helper[[snake_case_template]](...)
}
