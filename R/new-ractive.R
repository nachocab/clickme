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

    writeLines("#' Translate the data object to the format expected by current template
#'
#' @param data input data object
#' @param opts options of current template
#' @return The opts variable with the opts$data variable filled in
translate <- function(data, opts) {
    translated_data <- data

    opts$data <- translated_data
    opts
}", opts$path$translator_file)

    writeLines(paste0("context(\"translate ", ractive_name, "\")

test_that(\"input data is translated to the format expected by the template\", {
    input_data <- data.frame()
    expected_data <- \"\"

    opts <- get_opts(\"", ractive_name ,"\")
    opts <- translate(input_data, opts)

    expect_equal(opts$data, expected_data)
})"), opts$path$translator_test_file)

}