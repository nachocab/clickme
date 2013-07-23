Chart$methods(

    #' Generate HTML style and script tags
    #'
    #' @param opts the options of the current template
    #' @export
    get_assets = function() {
        styles_and_scripts <- paste0(c(get_styles(), get_scripts()), collapse="\n")
        styles_and_scripts
    },

    #' Generate HTML script tags
    #'
    #' @param opts the options of the current template
    #' @export
    get_scripts = function() {
        scripts <- paste(sapply(internal$config$scripts, function(script_path){
            script_path <- get_asset_path(script_path)
            gettextf("<script src=\"%s\"></script>", script_path)
        }), collapse="\n")

        scripts
    },

    #' Generate HTML style tags
    #'
    #' @param opts the options of the current template
    #' @export
    get_styles = function() {
        styles <- paste(sapply(internal$config$styles, function(style_path){
            style_path <- get_asset_path(style_path)
            gettextf("<link href=\"%s\" rel=\"stylesheet\">", style_path)
        }), collapse="\n")

        styles
    },

    get_asset_path = function(path){
        if (!grepl("^http://", path)){
            if (grepl("\\$shared/", path)) {
                path <- gsub("\\$shared/", "", path)
                path <- file.path(internal$file$relative_path$shared_assets, path)
            } else {
                path <- file.path(internal$file$relative_path$template_assets, path)
            }
        }

        path
    }

)