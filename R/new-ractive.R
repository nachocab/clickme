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
    - df2json

require_server: no

original_url:

", opts$path$template_config_file)

    writeLines("get_data_as_json <- function(opts) {
    library(df2json)
    data <- as.data.frame(opts$data, stringsAsFactors=FALSE)
    json_data <- df2json(data)

    json_data
}", opts$path$translator_file)

    writeLines(paste0("context(\"translate ", ractive_name, "\")

test_that(\"input data is translated to the format expected by the template\", {
    opts <- get_opts(\"", ractive_name ,"\")
    opts$data <- data.frame()
    expected_data <- \"\"

    json_data <- get_data_as_json(opts)

    expect_equal(json_data, expected_data)
})"), opts$path$translator_test_file)

}