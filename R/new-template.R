#' Creates a new template
#'
#' This creates the folder structure with the files that a template needs.
#' @param template_name name of the template
#' @param replace flag that indicates what to do when there is another template of the same name, default FALSE
#' @export
new_template <- function(template_name, coffee = FALSE, replace = FALSE) {

    # This is a bit of a hack, we'll have to change it when templates start inheriting from other Chart
    template <- Chart$new()
    template$internal$file$names$template <- camel_case(template_name)
    template$get_default_names_and_paths()
    paths <- template$internal$file$paths

    if (replace){
        unlink(file.path(getOption("clickme_templates_path"), template_name), recursive = TRUE)
    } else {
        if (file.exists(paths$Template)) {
            stop(gettextf("\n\n\tThe %s template already exists\n\t(use replace = TRUE if you want to replace it):\n\t%s",
                          template$internal$file$names$template,
                          paths$Template))
        }
    }

    dir.create(paths$Template)
    dir.create(paths$template)
    dir.create(paths$template_assets)
    dir.create(paths$translator)
    dir.create(paths$tests)

    if (coffee){
        writeLines(get_template_contents_coffee(), paths$template_coffee_file)
    } else {
        writeLines(get_template_contents(), paths$template_file)
    }
    writeLines(get_config_contents(template_name), paths$config_file)
    writeLines(get_translator_contents(template_name), paths$translator_file)
    writeLines(get_translator_test_contents(template_name), paths$translator_test_file)

    message("Template created at: ", paths$Template)

    invisible(template)
}

get_template_contents <- function() {
    "<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>
        <base target=\"_blank\"> <!-- open all links on a new tab -->

        <title>{{{ params$title }}}</title>

        {{{ get_assets() }}}
    </head>

    <body>
        <script type=\"text/javascript\">

            var data = {{ data }};

        </script>
    </body>
</html>
"
}

get_template_contents_coffee <- function() {
    "<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>
        <base target=\"_blank\"> <!-- open all links on a new tab -->

        <title>{{{ params$title }}}</title>

        {{{ get_assets() }}}
    </head>

    <body>
        <script type=\"text/javascript\">
        ```{r engine=\"coffee\", results=\"asis\", echo = FALSE}

            data = {{ data }}

        ```
        </script>
    </body>
</html>
"
}

get_translator_contents <- function(template_name){
    paste0(template_name, " <- setRefClass(\"", template_name, "\",

    contains = \"Chart\",

    methods = list(

        get_data = function(){
            data <<- params$x
        }

    )
)

", get_translator_helper_contents(template_name), "
")
}

get_translator_helper_contents <- function(template_name) {
    snake_template_name <- snake_case(template_name)

    paste0("clickme_helper$", snake_template_name," <- function(x,...){
    params <- list(x = x, ...)
    ", snake_template_name, " <- ", template_name, "$new(params)

    ", snake_template_name, "$display()
}
")
}

get_translator_test_contents <- function(template_name) {
    paste0("context(\"", template_name, "\")

test_that(\"get_data works\", {
    params <- list(x = 1:10)
    ", tolower(template_name), " <- ", template_name, "$new(params)
    ", tolower(template_name), "$get_data()
    expect_equal(", tolower(template_name), "$data, 1:10)
})
")
}

get_config_contents <- function(template_name) {
    paste0("info: |-
    Describe what this template does

demo: |-
    data <- 1:10
    clickme(", snake_case(template_name), ", data)

scripts:
    - $shared/d3.v3.2.7.js

styles:
    - $shared/clickme.css

require_packages:

require_server: no

")
}
