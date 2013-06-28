Template$methods(

    blank = function(name, overwrite = FALSE) {
        opts <- get_default_opts(template_name)

        config_contents <- get_config_contents()
        translator_contents <- get_translator_contents()
        translator_test_contents <- get_translator_test_contents(template_name)

        if (overwrite){
            unlink(file.path(getOption("clickme_templates_path"), template_name), recursive = TRUE)
        } else {
            if (file.exists(file_structure$paths$template)) stop("The ", opts$names$template, " template already exists: ", file_structure$paths$template)
        }

        sapply(c(file_structure$paths$template,
                 file_structure$paths$template_assets), function(path){
                    dir.create(path)
                 })

        sapply(c(file_structure$paths$template_file,
                 file_structure$paths$config_file,
                 file_structure$paths$translator_test_file,
                 file_structure$paths$translator_file), function(path){
                    file.create(path)
                 })

        writeLines(config_contents, file_structure$paths$config_file)
        writeLines(translator_contents, file_structure$paths$translator_file)
        writeLines(translator_test_contents, file_structure$paths$translator_test_file)

        message("template created at: ", file_structure$paths$template, "\n")
        message("You edit the template file by running: \nfile.edit(\"", file_structure$paths$template_file, "\")\n")

        invisible(opts)
    }

)

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
