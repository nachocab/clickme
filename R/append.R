append_scripts <- function(opts) {
    paste(sapply(opts$template_config$scripts, function(script_path){
        script_path <- file.path(opts$relative_scripts_path, script_path) # we could add a is_local option to config.yml so URLs can be used
        paste0("<script src=\"", script_path, "\"></script>")
    }), collapse="\n")
}

append_styles <- function(opts) {
    paste(sapply(opts$template_config$styles, function(style_path){
        style_path <- file.path(opts$relative_styles_path, style_path)
        paste0("<link href=\"", style_path, "\" rel=\"stylesheet\">")
    }), collapse="\n")
}