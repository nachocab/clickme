#' Create a new clickme visualization
#'
#' \code{clickme()} is used to create a clickme visualization.
#'
#' There are four ways to call \code{clickme}:
#' \itemize{
#'    \item \code{clickme(template, arguments)}
#'    \item \code{clickme(arguments)}
#'    \item \code{clickme(template)}
#'    \item \code{clickme()}
#'   }
#'
#' The first form is recommended for code that is run from a script. It sets the
#' template and the arguments to be used.
#' The second form is recommended for quick command line input. Instead of setting
#' the template, it uses the previously used template.
#' The third form sets the template, but doesn't generate any visualization. This is
#' useful when combined with the second form.
#' The fourth way returns the current template.
#'
#' @param template template used to generate the visualization
#' @param ... arguments passed to the template
#' @export
#' @include utils.R
clickme <- function(template, ...){

    # Fourth form: clickme(), return the current template
    if (missing(template))
        return(getOption("clickme_current_template"))

    # Second form: clickme(x, y), set the current template to the
    # previously used template (current template), or if not defined,
    # the default template, or the "points" template.
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
        # Third form: clickme(template), set the current template
        # Validate that the template exists
        template_path <- file.path(getOption("clickme_templates_path"), camel_case(template))
        if (!file.exists(template_path)){
            stop(sprintf("\n\tThe %s template is not installed in path %s\n", template, template_path), call. = FALSE)
        }
        options(clickme_current_template = template)
    } else {
        # First form: clickme(template, x, y)
        reload_translators()

        snake_case_template <- snake_case(template)
        camel_case_template <- camel_case(template)
        if (snake_case_template %notin% names(clickme_helper)){
            stop(sprintf("\n\tThe %s template is missing a helper function or is not installed in %s\n",
                          camel_case_template,
                          getOption("clickme_templates_path")),
            call. = FALSE)
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

