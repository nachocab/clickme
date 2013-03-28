
validate_ractive <- function(opts) {
    if (!file.exists(opts$path$ractive)) stop(opts$name$ractive, " ractive not found in: ", get_root_path(), "\n(Use one of: ", paste(plain_list_ractives(), collapse=", "), ")")
    if (!file.exists(opts$path$template)) stop(opts$name$template, " directory not found in: ", opts$path$ractive)
    if (!file.exists(opts$path$template_file)) stop(opts$name$template_file, " not found in: ", opts$path$template)
    if (!file.exists(opts$path$translator_file)) stop(opts$name$translator_file, " not found in: ", opts$path$template)
    if (!file.exists(opts$path$template_config_file)) stop(opts$name$template_config_file, " not found in: ", opts$path$template)

    if (!is.null(opts$template_config$require_packages)){
        missing_packages <- opts$template_config$require_packages[!is.installed(opts$template_config$require_packages)]

        if (length(missing_packages) != 0){
            message("The ", opts$name$ractive,
                    " ractive requires the following packages to be installed:\n\n",
                    paste0(missing_packages, collapse="\n"),
                    "\nPress ENTER and they will be installed automatically. Type 'c' if you prefer installing them yourself.")
            response <- readline()
            if (tolower(response) == "c"){
                message("Try install.packages(", paste0(missing_packages, collapse=","), ")")
                invisible(return())
            } else {
                install.packages(missing_packages)
            }
        }
    }

    sapply(c(opts$template_config$styles, opts$template_config$scripts), function(style_or_script){
        if (!grepl("^http", style_or_script)){
            path <- file.path(opts$path$external, style_or_script)
            if (!file.exists(path)) stop(style_or_script, " not found at: ", path)
        }
    })

    invisible(TRUE)
}