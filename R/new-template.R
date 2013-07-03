get_template_contents <- function(template_name) {
    paste0("<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>

    <title>{{{ params$title }}}</title>

    {{{ .self$get_assets() }}}

  </head>

  <body>

    <script type=\"text/javascript\">
      var data = {{ data }};
    </script>

    <div class = \"code\">
      {{{ params$code }}}
    </div>

  </body>
</html>
")
}

get_translator_test_contents <- function(template_name) {
    paste0("context(\" ", template_name, "\")

    test_that(\"get_data works\", {
        params <- list(data = 1:10)
        ", tolower(template_name), " <- ", template_name, "$new(params)
        ", tolower(template_name), "$get_data()
        expect_equal(", tolower(template_name), ", 1:10)
    })

})

")
}

get_translator_contents <- function(template_name){
    paste0(template_name, " <- setRefClass(\"", template_name, "\",

    contains = \"Chart\",

    methods = list(

        get_data = function(){
            data <<- params$data
        }

    )
)

")
}

get_config_contents <- function() {
    "info: |-

original_url:

demo: |-

scripts:

styles:

require_packages:

require_server: no
"
}

#' Creates a new template
#'
#' This creates the folder structure with the files that a template needs.
#' @param template_name name of the template
#' @param overwrite flag that indicates what to do when there is another template of the same name, default FALSE
#' @export
new_template <- function(template_name, overwrite = FALSE) {
    template <- Chart$new()
    template$get_params()
    template$name <- template_name
    template$get_unvalidated_file_structure()

    template_contents <- get_template_contents()
    config_contents <- get_config_contents()
    translator_contents <- get_translator_contents(template_name)
    translator_test_contents <- get_translator_test_contents(template_name)

    if (overwrite){
        unlink(file.path(getOption("clickme_templates_path"), template_name), recursive = TRUE)
    } else {
        if (file.exists(template$file_structure$paths$Template)) stop("The ", template$file_structure$names$template, " template already exists: ", template$file_structure$paths$Template)
    }

    sapply(c(template$file_structure$paths$Template,
             template$file_structure$paths$template,
             template$file_structure$paths$template_assets,
             template$file_structure$paths$translator,
             template$file_structure$paths$tests), function(path){
                dir.create(path)
             })

    sapply(c(template$file_structure$paths$template_file,
             template$file_structure$paths$config_file,
             template$file_structure$paths$translator_test_file,
             template$file_structure$paths$translator_file), function(path){
                file.create(path)
             })

    writeLines(template_contents, template$file_structure$paths$template_file)
    writeLines(config_contents, template$file_structure$paths$config_file)
    writeLines(translator_contents, template$file_structure$paths$translator_file)
    writeLines(translator_test_contents, template$file_structure$paths$translator_test_file)

    message("Chart created at: ", template$file_structure$paths$Template, "\n")

    invisible(template)
}