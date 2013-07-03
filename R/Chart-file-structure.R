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
        file_structure <<- list()
        file_structure$names$template <<- name
        file_structure$names$template_assets <<- "assets"
        file_structure$names$shared_assets <<- "shared_assets"
        file_structure$names$output_assets <<- "clickme_assets"

        # file names
        file_structure$names$template_file <<- "template.Rmd"
        file_structure$names$template_coffee_file <<- "template.coffee.Rmd"
        file_structure$names$config_file <<- "config.yml"
        file_structure$names$translator_file <<- paste0(file_structure$names$template, ".R")
        file_structure$names$translator_test_file <<- paste0("test-", file_structure$names$template, ".R")
    },

    get_default_paths = function() {

        # folder absolute paths
        file_structure$paths$Template <<- file.path(getOption("clickme_templates_path"), file_structure$names$template)
        file_structure$paths$template <<- file.path(file_structure$paths$Template, "template")
        file_structure$paths$translator <<- file.path(file_structure$paths$Template, "translator")
        file_structure$paths$tests <<- file.path(file_structure$paths$Template, "tests")
        file_structure$paths$template_assets <<- file.path(file_structure$paths$Template, file_structure$names$template_assets)

        # file absolute paths
        file_structure$paths$template_file <<- file.path(file_structure$paths$template, file_structure$names$template_file)
        file_structure$paths$template_coffee_file <<- file.path(file_structure$paths$template, file_structure$names$template_coffee_file)
        file_structure$paths$config_file <<- file.path(file_structure$paths$Template, file_structure$names$config_file)
        file_structure$paths$translator_file <<- file.path(file_structure$paths$translator, file_structure$names$translator_file)
        file_structure$paths$translator_test_file <<- file.path(file_structure$paths$tests, file_structure$names$translator_test_file)
        file_structure$paths$shared_assets <<- file.path(getOption("clickme_templates_path"), "..", file_structure$names$shared_assets)

    },

    get_output_file_name = function() {

        if (is.null(params$file)){
            if (is.null(params$file_name)){
                file_structure$names$output_file <<- paste0("temp-", file_structure$names$template, ".html")
            } else {
                if (!grepl(".\\.html$", params$file_name)) {
                    file_structure$names$output_file <<- paste0(params$file_name, ".html")
                } else {
                    file_structure$names$output_file <<- params$file_name
                }
            }
        } else {
            if (!is.null(params$file_name)) {
                warning(gettextf("The \"file_name\" argument was ignored because the \"file\" argument was present: %s", params$file))
            }

            if (!grepl(".\\.html$", params$file)) {
                params$file <<- paste0(params$file, ".html")
            }
            file_structure$names$output_file <<- basename(params$file)
        }

    },

    get_output_paths = function() {

        if (is.null(params$file)){
            if (is.null(params$dir)){
                file_structure$paths$output <<- getOption("clickme_output_path")
            } else {
                file_structure$paths$output <<- params$dir
            }
            file_structure$paths$output_file <<- file.path(file_structure$paths$output, file_structure$names$output_file)
        } else {
            if (!is.null(params$dir)) warning(gettextf("The \"dir\" argument was ignored because the \"file\" argument was present: %s", params$file))

            file_structure$paths$output <<- dirname(params$file)
            file_structure$paths$output_file <<- params$file
        }

        file_structure$paths$output_template_assets <<- file.path(file_structure$paths$output, file_structure$names$output_assets, file_structure$names$template)
        file_structure$paths$output_shared_assets <<- file.path(file_structure$paths$output, file_structure$names$output_assets)

        # relative paths (they go in the HTML files)
        file_structure$relative_path$template_assets <<- file.path(file_structure$names$output_assets, file_structure$names$template)
        file_structure$relative_path$shared_assets <<- file.path(file_structure$names$output_assets)

    },

    validate_file_structure = function() {

        if (!file.exists(getOption("clickme_templates_path"))) {
            stop(gettextf("getOption(\"clickme_templates_path\") doesn't contain a valid path: %s", getOption("clickme_templates_path")))
        }

        if (!file.exists(file_structure$paths$Template)) {
            stop(gettextf("There is no template %s located in: %s ", file_structure$names$template, file_structure$paths$Template))
        }

        # template.Rmd must exist, unless coffee is true and template.coffee.Rmd exists
        if (!file.exists(file_structure$paths$template_file) && !(params$coffee && file.exists(file_structure$paths$template_coffee_file))){
            stop(gettextf("The %s template doesn't contain a template file in: %s ", file_structure$names$template, file_structure$paths$template_file))
        }

        if (!file.exists(file_structure$paths$config_file)) {
            stop(gettextf("The %s template doesn't contain a configuration file in: %s ", file_structure$names$template, file_structure$paths$config_file))
        }

        if (!file.exists(file_structure$paths$translator_file)) {
            stop(gettextf("The %s template doesn't contain a translator file in: %s ", file_structure$names$template, file_structure$paths$translator_file))
        }

        if (!file.exists(file_structure$paths$output)){
            dir.create(file_structure$paths$output)
        }

    }

)