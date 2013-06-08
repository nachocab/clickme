get_translator_test_contents <- function() {
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
    data <- as.data.frame(opts$data, stringsAsFactors = FALSE)
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

require_coffeescript: no

"
}

#' Creates a new template
#'
#' This creates the folder structure with the files that a template needs.
#' @param template_name name of the template
#' @param overwrite flag that indicates what to do when there is another template of the same name, default FALSE
#' @export
new_template <- function(template_name, overwrite = FALSE) {
    opts <- get_default_paths(template_name)

    config_contents <- get_config_contents()
    translator_contents <- get_translator_contents()
    translator_test_contents <- get_translator_test_contents()

    if (overwrite){
        unlink(file.path(getOption("clickme_templates_path"), template_name), recursive = TRUE)
    } else {
        if (file.exists(opts$path$template)) stop("The ", opts$name$template, " template already exists: ", opts$path$template)
    }

    sapply(c(opts$path$template,
             opts$path$template_assets,
             opts$path$template,
             opts$path$data), function(path){
                dir.create(path)
             })

    sapply(c(opts$path$template_file,
             opts$path$config_file,
             opts$path$translator_test_file,
             opts$path$translator_file), function(path){
                file.create(path)
             })

    writeLines(config_contents, opts$path$config_file)
    writeLines(translator_contents, opts$path$translator_file)
    writeLines(translator_test_contents, opts$path$translator_test_file)

    message("template created at: ", opts$path$template, "\n")
    message("You can start by editing the template file using:\nfile.edit(\"", opts$path$template_file, "\")")

    invisible()
}