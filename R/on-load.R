#' Straight from R to JS: Create interactive visualizations from R
#'
#' @section Package options:
#'
#' Clickme uses the following \code{options} to configure behaviour:
#'
#' \itemize{
#'
#'   \item \code{clickme_templates_path}: path where the templates are stored
#'
#'   \item \code{clickme_output_path}: path where the generated visualizations are saved (along with their dependencies)
#'
#' }
#' @docType package
#' @name clickme
#' @author Nacho Caballero <\url{http://reasoniamhere.com}>
#' @references Full documentation: \url{https://github.com/nachocab/clickme/wiki};
NULL


set_default_paths <- function() {
    opts <- options()
    opts_clickme <- list(
      clickme_templates_path = system.file("templates", package = "clickme"),
      clickme_output_path = system.file("output", package = "clickme")
    )

    # only set options that have not already been set by the user
    to_set <- !(names(opts_clickme) %in% names(opts))
    if(any(to_set)) options(opts_clickme[to_set])
}


# returns a list of the objects defined by the source files in each path
get_objects <- function(paths) {
    functions <- lapply(paths, function(path) {
        # TODO: handle case when path doesn't exist, no files in path, etc.

        # ensure the main source file is loaded before the helper files
        source_files <- list.files(file.path(path, "R"), full.names = TRUE)
        main_source_file <- file.path(path, "R", paste0(basename(path), ".R"))
        source_files <- move_in_front(main_source_file, source_files)

        temp <- new.env()
        sapply(source_files, function(source_file){
            suppressWarnings(sys.source(source_file, envir = temp))
        })
        ls(temp)
    })

    functions
}


#' This function load the R source files in templates/<Template>/R
#' It first checks that those files are not polluting the global namespace. They are only allowed to define methods to their <Template> object
#'
load_installed_templates <- function() {
    template_paths <- list.files(getOption("clickme_templates_path"), full.names = TRUE)
    template_objects <- get_objects(template_paths)

    # ensure that each template adds a single object to the global namespace, with the correct name
    sapply(1:length(template_paths), function(t){
        if (template_objects[[t]] != basename(template_paths[t])) {
            stop(error_title("Namespace Error"),
                 "The following objects are being defined in the global namespace instead of as a method of ", basename(template_paths[t]) ,":\n\n",
                 enumerate(template_objects[[t]]),
                 "\n\n")
        }
    })

    # ensure that main source files are loaded before helper files
    source_files <- list.files(file.path(template_paths, "R"), full.names = TRUE)
    main_source_files <- file.path(template_paths, "R", sapply(template_paths, function(path) paste0(basename(path), ".R")))
    source_files <- move_in_front(main_source_files, source_files)

    suppressWarnings(sapply(source_files, source))

    return()
}

.onLoad <- function(libname, pkgname) {
  set_default_paths()

  load_installed_templates()
}
