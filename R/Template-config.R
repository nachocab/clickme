Template$methods(

    get_config = function() {
        config <<- yaml.load_file(file_structure$paths$config_file)

        validate_required_packages()
        validate_assets()
    },

    validate_required_packages = function() {
        if (!is.null(config$require_packages)){
            missing_packages <- config$require_packages[!is.installed(config$require_packages)]

            if (length(missing_packages) != 0){
                message(separator())
                message(gettextf("The %s template requires the following packages:\n\n%s\nPress Enter to install them automatically or \"c\" to cancel.",
                        file_structure$names$template,
                        paste0(missing_packages, collapse="\n"))
                )
                response <- readline()
                if (tolower(response) == "c"){
                    message(gettextf("Try running: install.packages(%s)", paste0(missing_packages, collapse=",")))
                    capture.output(return())
                } else {
                    install.packages(missing_packages)
                }
                message(separator())
            }

            sapply(config$require_packages, library, character.only = TRUE)
        }
    },

    get_template_and_shared_assets = function() {

        local_assets <- grep("^http://", c(config$styles, config$scripts), value = TRUE, invert = TRUE)
        if (length(local_assets) > 0){
            shared_assets <- grep("^\\$shared/", local_assets, value = TRUE)
            if (length(shared_assets) > 0){
                template_assets <- setdiff(local_assets, shared_assets)
                shared_assets <- str_match(shared_assets, "^\\$shared/(.+)")[,2]
            } else {
                template_assets <- local_assets
                shared_assets <- NULL
            }
            assets <- list(template = template_assets, shared = shared_assets)
        } else {
            assets <- NULL
        }

        assets
    },

    validate_assets = function() {
        assets <- get_template_and_shared_assets()

        sapply(assets$template, function(asset){
            path <- file.path(file_structure$paths$template_assets, asset)
            if (!file.exists(path)) stop(asset, " not found at: ", path)
        })

        sapply(assets$shared, function(asset){
            path <- file.path(file_structure$paths$shared_assets, asset)
            if (!file.exists(path)) stop(asset, " not found at: ", path)
        })
    }

)