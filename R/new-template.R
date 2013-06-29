get_translator_test_contents <- function(template_name) {
    paste0("context(\"translate ", template_name, "\")

test_that(\"input data is translated to the format expected by the template\", {
    opts <- get_opts(\"", template_name ,"\")
    opts$data <- data.frame() # assign to this variable the typical input data you would use in R
    expected_data <- \"\" # assign to this variable the same data in the format expected by the template

    json_data <- get_data_as_json(opts)
    expect_equal(json_data, expected_data)
})")
}

get_translator_contents <- function(){
    "get_data_as_json <- function(opts) {
    json_data <- df2json(data)

    json_data
}

get_data_as_json_file <- function(opts) {
    opts$data <- get_data_as_json(opts)
    json_file <- create_data_file(opts, \"json\")

    json_file
}"
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
    template <- Template$new()
    template$get_params()
    template$name <- template_name
    template$get_unvalidated_file_structure()

    config_contents <- get_config_contents()
    translator_contents <- get_translator_contents()
    translator_test_contents <- get_translator_test_contents(template_name)

    if (overwrite){
        unlink(file.path(getOption("clickme_templates_path"), template_name), recursive = TRUE)
    } else {
        if (file.exists(template$file_structure$paths$template)) stop("The ", template$file_structure$names$template, " template already exists: ", template$file_structure$paths$template)
    }

    sapply(c(template$file_structure$paths$template,
             template$file_structure$paths$template_assets), function(path){
                dir.create(path)
             })

    sapply(c(template$file_structure$paths$template_file,
             template$file_structure$paths$config_file,
             template$file_structure$paths$translator_test_file,
             template$file_structure$paths$translator_file), function(path){
                file.create(path)
             })

    writeLines(config_contents, template$file_structure$paths$config_file)
    writeLines(translator_contents, template$file_structure$paths$translator_file)
    writeLines(translator_test_contents, template$file_structure$paths$translator_test_file)

    message("template created at: ", template$file_structure$paths$template, "\n")
    message("You edit the template file by running: \nfile.edit(\"", template$file_structure$paths$template_file, "\")\n")

    invisible(template)
}