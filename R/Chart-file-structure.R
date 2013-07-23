Chart$methods(

    get_file_structure = function() {
        get_unvalidated_file_structure()
        validate_file_structure()
    },

    get_unvalidated_file_structure = function() {
        get_default_names_and_paths()
        get_output_file_name()
        get_output_paths()
    },

    get_default_names_and_paths = function() {
        get_default_names()
        get_default_paths()
    },

    get_default_names = function() {

        # folder names
        internal$file$names$template_assets <<- "assets"
        internal$file$names$shared_assets <<- "shared_assets"
        internal$file$names$output_assets <<- "clickme_assets"

        # file names
        internal$file$names$template_file <<- "template.Rmd"
        internal$file$names$template_coffee_file <<- "template.coffee.Rmd"
        internal$file$names$config_file <<- "config.yml"
        internal$file$names$translator_file <<- paste0(internal$file$names$template, ".R")
        internal$file$names$translator_test_file <<- paste0("test-", internal$file$names$template, ".R")
    },

    get_default_paths = function() {

        # folder absolute paths
        internal$file$paths$Template <<- file.path(getOption("clickme_templates_path"), internal$file$names$template)
        internal$file$paths$template <<- file.path(internal$file$paths$Template, "template")
        internal$file$paths$translator <<- file.path(internal$file$paths$Template, "translator")
        internal$file$paths$tests <<- file.path(internal$file$paths$Template, "tests")
        internal$file$paths$template_assets <<- file.path(internal$file$paths$Template, internal$file$names$template_assets)

        # file absolute paths
        internal$file$paths$template_file <<- file.path(internal$file$paths$template, internal$file$names$template_file)
        internal$file$paths$template_coffee_file <<- file.path(internal$file$paths$template, internal$file$names$template_coffee_file)
        internal$file$paths$config_file <<- file.path(internal$file$paths$Template, internal$file$names$config_file)
        internal$file$paths$translator_file <<- file.path(internal$file$paths$translator, internal$file$names$translator_file)
        internal$file$paths$translator_test_file <<- file.path(internal$file$paths$tests, internal$file$names$translator_test_file)
        internal$file$paths$shared_assets <<- file.path(getOption("clickme_templates_path"), "..", internal$file$names$shared_assets)

    },

    get_output_file_name = function() {

        if (is.null(params[["file_path"]])){
            if (is.null(params[["file"]])){
                internal$file$names$output_file <<- paste0("temp-", internal$file$names$template, ".html")
            } else {
                if (!grepl(".\\.html$", params[["file"]])) {
                    internal$file$names$output_file <<- paste0(params[["file"]], ".html")
                } else {
                    internal$file$names$output_file <<- params[["file"]]
                }
            }
        } else {
            if (!is.null(params[["file"]])) {
                message(gettextf("\n\tThe \"file\" argument was ignored because the \"file_path\" argument was present: %s", params[["file_path"]]), "\n")
            }

            if (!grepl(".\\.html$", params[["file_path"]])) {
                params[["file_path"]] <<- paste0(params[["file_path"]], ".html")
            }
            internal$file$names$output_file <<- basename(params[["file_path"]])
        }

    },

    # Absolute and relative paths to output folder, output file, and output template and shared assets
    get_output_paths = function() {

        if (is.null(params[["file_path"]])){
            if (is.null(params$dir)){
                internal$file$paths$output <<- getOption("clickme_output_path")
            } else {
                internal$file$paths$output <<- params$dir
            }
            internal$file$paths$output_file <<- file.path(internal$file$paths$output, internal$file$names$output_file)
        } else {
            if (!is.null(params$dir)) {
                message(gettextf("\n\tThe \"dir\" argument was ignored because the \"file_path\" argument was present\n\t(use \"file\" if you just want to specify the file name):\n\t%s\n", params[["file_path"]]))
            }

            internal$file$paths$output <<- dirname(params[["file_path"]])
            internal$file$paths$output_file <<- params[["file_path"]]
        }

        internal$file$paths$output_template_assets <<- file.path(internal$file$paths$output, internal$file$names$output_assets, internal$file$names$template)
        internal$file$paths$output_shared_assets <<- file.path(internal$file$paths$output, internal$file$names$output_assets)

        # relative paths (they go in the HTML files)
        internal$file$relative_path$template_assets <<- file.path(internal$file$names$output_assets, internal$file$names$template)
        internal$file$relative_path$shared_assets <<- file.path(internal$file$names$output_assets)

    },

    validate_file_structure = function() {

        if (!file.exists(getOption("clickme_templates_path"))) {
            stop(gettextf("getOption(\"clickme_templates_path\") doesn't contain a valid path: %s", getOption("clickme_templates_path")))
        }

        if (!file.exists(internal$file$paths$Template)) {
            stop(gettextf("There is no template %s located in: %s ", internal$file$names$template, internal$file$paths$Template))
        }

        # template.Rmd must exist, unless template.coffee.Rmd exists
        if (!file.exists(internal$file$paths$template_file) && !file.exists(internal$file$paths$template_coffee_file)){
            stop(gettextf("The %s template doesn't contain a template file in: %s ", internal$file$names$template, internal$file$paths$template_file))
        }

        if (!file.exists(internal$file$paths$config_file)) {
            stop(gettextf("The %s template doesn't contain a configuration file in: %s ", internal$file$names$template, internal$file$paths$config_file))
        }

        if (!file.exists(internal$file$paths$translator_file)) {
            stop(gettextf("The %s template doesn't contain a translator file in: %s ", internal$file$names$template, internal$file$paths$translator_file))
        }

        if (!file.exists(internal$file$paths$output)){
            dir.create(internal$file$paths$output)
        }

    }

)