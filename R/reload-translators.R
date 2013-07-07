
#' Traverses a list of paths and determines what objects are defined in the source files that appear in the "translator" folder of each path
#' It returns a list of sourced objects.
#' This is done to make control what objects get added to the global namespace
get_sourced_objects <- function(paths) {
    sourced_objects <- lapply(paths, function(path) {
        translator_files <- list.files(file.path(path, "translator"), full.names = TRUE)

        # the call to camel_case is to avoid a weird issue with lowercase folders renamed to uppercase in OSX
        main_translator_file <- file.path(path, "translator", paste0(camel_case(basename(path)), ".R"))

        # ensure the main translator file is loaded before the helper files
        translator_files <- move_in_front(main_translator_file, translator_files)

        temp_environment <- new.env()
        sapply(translator_files, function(translator_file){
            suppressWarnings(sys.source(translator_file, envir = temp_environment))
        })

        ls(temp_environment)
    })

    names(sourced_objects) <- paths
    # remove empty list elements
    sourced_objects <- sourced_objects[lapply(sourced_objects, length) > 0]

    sourced_objects
}


#' Load the translator files in each template
#'
#' Translators are only allowed to create one object with the name of their template and a clickme helper function in the global namespace.
#'
reload_translators <- function() {
    clickme_helper <<- list()

    template_paths <- list.files(getOption("clickme_templates_path"), full.names = TRUE)
    template_objects <- get_sourced_objects(template_paths)

    # some paths might have been removed because they didn't contain any objects, so we ignore them
    template_paths <- names(template_objects)

    # we don't need the paths anymore
    template_objects <- unname(template_objects)

    # Ensure that each translator only creates one object with the name of its template and a clickme helper function
    sapply(1:length(template_paths), function(t){
        template_name <- basename(template_paths[t])

        if (length(setdiff(template_objects[[t]], template_name)) != 0 && setdiff(template_objects[[t]], template_name) != "clickme_helper") {

            # don't report any valid objects
            template_objects[[t]] <- setdiff(template_objects[[t]], valid_objects)

            stop(error_title("Namespace Error"),
                 "The ", basename(template_paths[t]), " template is defining the following objects in the global namespace instead of as methods:\n\n",
                 enumerate(template_objects[[t]]),
                 "\n\n")
        }
    })

    # ensure that the translator file where the template is defined gets loaded before any of the other helper files
    translator_files <- list.files(file.path(template_paths, "translator"), full.names = TRUE)
    main_translator_files <- file.path(template_paths, "translator", sapply(template_paths, function(path) paste0(basename(path), ".R")))
    translator_files <- move_in_front(main_translator_files, translator_files)

    suppressWarnings(sapply(translator_files, source))

    return()
}