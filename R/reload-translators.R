# returns a list of the objects defined by the source files in each path
get_objects <- function(paths) {
    functions <- lapply(paths, function(path) {
        # TODO: handle case when path doesn't exist, no files in path, etc.

        # ensure the main translator file is loaded before the helper files
        translator_files <- list.files(file.path(path, "translator"), full.names = TRUE) # TODO: "translator" should be stored in a variable
        main_translator_file <- file.path(path, "translator", paste0(basename(path), ".R"))
        translator_files <- move_in_front(main_translator_file, translator_files)

        temp <- new.env()
        sapply(translator_files, function(translator_file){
            suppressWarnings(sys.source(translator_file, envir = temp))
        })

        ls(temp)
    })

    names(functions) <- paths
    functions <- functions[lapply(functions, length) > 0]

    functions
}


#' Load the translator files in each template
#'
#' Translators are only allowed to create one object with the name of their template in the global namespace.
#'
reload_translators <- function() {
    clickme_helper <<- list()

    template_paths <- list.files(getOption("clickme_templates_path"), full.names = TRUE)
    template_objects <- get_objects(template_paths)

    # some paths might have been removed because they didn't contain any objects
    template_paths <- names(template_objects)
    template_objects <- unname(template_objects)

    # Ensure that each translator only creates one object with the name of its template. Optionally, it may also add a helper function as an element of the clickme_helper list.
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

    # ensure that main translator files are loaded before the helper translator files
    translator_files <- list.files(file.path(template_paths, "translator"), full.names = TRUE)
    main_translator_files <- file.path(template_paths, "translator", sapply(template_paths, function(path) paste0(basename(path), ".R")))
    translator_files <- move_in_front(main_translator_files, translator_files)

    suppressWarnings(sapply(translator_files, source))

    return()
}