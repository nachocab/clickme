Template$methods(

    get_file_structure = function(){

        # folder names
        file_structure$names$template <<- tolower(as.character(class(.self))) # TODO: change this to snake case
        file_structure$names$template_assets <<- "assets"
        file_structure$names$shared_assets <<- "__shared_assets"
        file_structure$names$output_assets <<- "clickme_assets"

        # file names
        file_structure$names$template_file <<- "template.Rmd"
        file_structure$names$template_coffee_file <<- "template.coffee.Rmd"
        file_structure$names$config_file <<- "config.yml"
        file_structure$names$translator_file <<- "translator.R"
        file_structure$names$translator_test_file <<- "test-translator.R"

        # folder absolute paths
        file_structure$paths$template <<- file.path(getOption("clickme_templates_path"), file_structure$names$template)
        file_structure$paths$template_assets <<- file.path(file_structure$paths$template, file_structure$names$template_assets)

        # file absolute paths
        file_structure$paths$template_file <<- file.path(file_structure$paths$template, file_structure$names$template_file)
        file_structure$paths$template_coffee_file <<- file.path(file_structure$paths$template, file_structure$names$template_coffee_file)
        file_structure$paths$config_file <<- file.path(file_structure$paths$template, file_structure$names$config_file)
        file_structure$paths$translator_file <<- file.path(file_structure$paths$template, file_structure$names$translator_file)
        file_structure$paths$translator_test_file <<- file.path(file_structure$paths$template, file_structure$names$translator_test_file)

        file_structure <- add_output_file_name(file_structure, file, file_name)
        file_structure <- add_output_paths(file_structure, file, dir)

        validate_paths()

    },

    validate_paths = function() {
        if (!file.exists(getOption("clickme_templates_path")))
            stop(gettextf("getOption(\"clickme_templates_path\") doesn't contain a valid path: %s", getOption("clickme_templates_path")))

        if (!file.exists(file_structure$paths$template))
            stop(gettextf("There is no template %s located in: %s ", params$names$template, file_structure$paths$template))

        if (!file.exists(file_structure$paths$template_file) && !(params$coffee && file.exists(file_structure$paths$template_coffee_file)))
            stop(gettextf("The %s template doesn't contain a template file in: %s ", params$names$template, file_structure$paths$template_file))

        if (!file.exists(file_structure$paths$config_file))
            stop(gettextf("The %s template doesn't contain a configuration file in: %s ", params$names$template, file_structure$paths$config_file))

        if (!file.exists(file_structure$paths$translator_file))
            stop(gettextf("The %s template doesn't contain a translator file in: %s ", params$names$template, file_structure$paths$translator_file))

        if (!file.exists(file_structure$paths$output)){
            dir.create(file_structure$paths$output)
        }
    },

    get_output_file_name = function(file = NULL, file_name = NULL) {
        if (is.null(file)){
            if (is.null(file_name)){
                file_structure$names$output_file <- paste0("temp-", file_structure$names$template, ".html")
            } else {
                if (!grepl(".\\.html$", file_name)) {
                    file_structure$names$output_file <- paste0(file_name, ".html")
                } else {
                    file_structure$names$output_file <- file_name
                }
            }
        } else {
            if (!is.null(file_name)) warning(gettextf("The \"file_name\" argument was ignored because the \"file\" argument was present: %s", file))

            if (!grepl(".\\.html$", file)) {
                file <- paste0(file, ".html")
            }
            file_structure$names$output_file <- basename(file)
        }
    },

    get_output_paths = function(file = NULL, dir = NULL) {
        if (is.null(file)){
            if (is.null(dir)){
                file_structure$paths$output <- getOption("clickme_output_path")
            } else {
                file_structure$paths$output <- dir
            }
            file_structure$paths$output_file <- file.path(file_structure$paths$output, file_structure$names$output_file)
        } else {
            if (!is.null(dir)) warning(gettextf("The \"dir\" argument was ignored because the \"file\" argument was present: %s", file))

            file_structure$paths$output <- dirname(file)
            file_structure$paths$output_file <- file
        }

        file_structure$paths$shared_assets <- file.path(getOption("clickme_templates_path"), file_structure$names$shared_assets)
        file_structure$paths$output_template_assets <- file.path(file_structure$paths$output, file_structure$names$output_assets, file_structure$names$template)
        file_structure$paths$output_shared_assets <- file.path(file_structure$paths$output, file_structure$names$output_assets)

        # relative paths (they go in the HTML files)
        file_structure$relative_path$template_assets <- file.path(file_structure$names$output_assets, file_structure$names$template)
        file_structure$relative_path$shared_assets <- file.path(file_structure$names$output_assets)
    }

)