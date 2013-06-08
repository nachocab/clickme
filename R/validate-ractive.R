
validate_ractive <- function(opts) {
    if (!file.exists(opts$path$ractive)) stop(opts$name$ractive, " ractive not found in: ", get_templates_path(), "\n(Use one of: ", paste(plain_list_ractives(), collapse=", "), ")")
    if (!file.exists(opts$path$template)) stop(opts$name$template, " directory not found in: ", opts$path$ractive)
    if (!file.exists(opts$path$template_file)) stop(opts$name$template_file, " not found in: ", opts$path$template)
    if (!file.exists(opts$path$translator_file)) stop(opts$name$translator_file, " not found in: ", opts$path$template)
    if (!file.exists(opts$path$config_file)) stop(opts$name$config_file, " not found in: ", opts$path$template)

    if (!is.null(opts$config$require_packages)){
        missing_packages <- opts$config$require_packages[!is.installed(opts$config$require_packages)]

        if (length(missing_packages) != 0){
            separator <- paste0(rep("=", 70, collapse = ""))
            message(separator)
            message("The ", opts$name$ractive,
                    " ractive requires the following packages to be installed:\n\n",
                    paste0(missing_packages, collapse="\n"),
                    "\nPress Enter to install them automatically or \"c\" to cancel.")
            response <- readline()
            if (tolower(response) == "c"){
                message("Try install.packages(", paste0(missing_packages, collapse=","), ")")
                capture.output(return())
            } else {
                install.packages(missing_packages)
            }
            message(separator)
        }

        sapply(opts$config$require_packages, library, character.only = TRUE)
    }

    sapply(c(opts$config$styles, opts$config$scripts), function(style_or_script){
        if (!grepl("^http", style_or_script)){
            path <- file.path(opts$path$external, style_or_script)
            if (!file.exists(path)) stop(style_or_script, " not found at: ", path)
        }
    })

    if (is.null(opts$config$require_server)){
        opts$config$require_server <- FALSE
    }

    if (is.null(opts$config$require_coffeescript)){
        opts$config$require_coffeescript <- FALSE
    }

    opts
}