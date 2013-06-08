#' Creates a new ractive
#'
#' This creates the folder structure with the files that a ractive needs.
#' @param ractive_name name of the ractive
#' @param overwrite flag that indicates what to do when there is another ractive of the same name, default FALSE
#' @export
new_ractive <- function(ractive_name, overwrite = FALSE) {
    opts <- add_ractive_opts(ractive_name)

    config_contents <- "info: |-

original_url:

demo: |-

scripts:

styles:

require_packages:

require_server: no

require_coffeescript: no

"

    translator_contents <- "get_data_as_json <- function(opts) {
    data <- as.data.frame(opts$data, stringsAsFactors = FALSE)
    json_data <- df2json(data)

    json_data
}

get_data_as_json_file <- function(opts) {
    opts$data <- get_data_as_json(opts)
    json_file <- create_data_file(opts, \"json\")

    json_file
}"

    translator_test_contents <- paste0("context(\"translate ", ractive_name, "\")

test_that(\"input data is translated to the format expected by the template\", {
    opts <- get_opts(\"", ractive_name ,"\")
    opts$data <- data.frame() # assign to this variable the typical input data you would use in R
    expected_data <- \"\" # assign to this variable the same data in the format expected by the template

    json_data <- get_data_as_json(opts)
    expect_equal(json_data, expected_data)
})")

    if (overwrite){
        unlink(file.path(get_templates_path(), ractive_name), recursive = TRUE)
    } else {
        if (file.exists(opts$path$ractive)) stop("The ", opts$name$ractive, " ractive already exists: ", opts$path$ractive)
    }

    sapply(c(opts$path$ractive,
             opts$path$external,
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

    message("Ractive created at: ", opts$path$ractive, "\n")
    message("You can start by editing the template file using:\nfile.edit(\"", opts$path$template_file, "\")")
}