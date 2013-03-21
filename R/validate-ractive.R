
validate_ractive <- function(opts) {
    if (!file.exists(opts$path$ractive)) stop(opts$name$ractive, " ractive not found in: ", get_root_path(), "\n(Use one of: ", paste(plain_list_ractives(), collapse=", "), ")")
    if (!file.exists(opts$path$template)) stop(opts$name$template, " directory not found in: ", opts$path$ractive)
    if (!file.exists(opts$path$template_file)) stop(opts$name$template_file, " not found in: ", opts$path$template)
    if (!file.exists(opts$path$translator_file)) stop(opts$name$translator_file, " not found in: ", opts$path$template)
    if (!file.exists(opts$path$template_config_file)) stop(opts$name$template_config_file, " not found in: ", opts$path$template)

    if (!is.null(opts$template_config$require_packages)){
        sapply(opts$template_config$require_packages, function(package_name){
            if (!is.installed(package_name)){
                install.packages(package_name)
            }
        })
    }

    invisible()
}