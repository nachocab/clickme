#' Creates a new ractive
#'
#' This creates the folder structure with the files that a ractive needs.
#' @param ractive_name name of the ractive
#' @param overwrite flag that indicates what to do when there is another ractive of the same name, default FALSE
#' @export
new_ractive <- function(ractive_name, overwrite = FALSE) {
    opts <- add_ractive_opts(ractive_name)

    if (overwrite){
        unlink(file.path(get_root_path(), ractive_name), recursive=TRUE)
    } else {
        if (file.exists(opts$path$ractive)) stop("The ", opts$name$ractive, " ractive already exists: ", opts$path$ractive)
    }

    message("Adding new ractive: ", opts$name$ractive)
    sapply(c(opts$path$ractive,
             opts$path$external,
             opts$path$template,
             opts$path$tests,
             opts$path$data), function(path){
                dir.create(path)
                message("Created directory: ", path)
             })

    sapply(c(opts$path$template_file,
             opts$path$template_config_file,
             opts$path$translator_test_file,
             opts$path$translator_file), function(path){
                file.create(path)
                message("Created file: ", path)
             })

    writeLines("info: |

valid_names:

name_comments: |

scripts:

styles:

default_parameters: {

}

require_packages:

require_server: no

original_url:

", opts$path$template_config_file)

    writeLines("#' Translate the data object to the format expected by the current template
#'
#' It returns the translated data object.
#'
#' @param data input data object
#' @param opts options used by current template
translate <- function(data, opts = NULL) {
    data
}", opts$path$translator_file)

    writeLines("context(\"translate\")

test_that(\"input data is translated to the format expected by the template\", {
    input_data <- data.frame()
    expected_data <- \"\"

    translated_input <- translate(input_data)
    expect_equal(translated_input, expected_data)
})", opts$path$translator_test_file)

}