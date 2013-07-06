# params:
# data
# height [default]
# width [default]
# padding [default]
# box [FALSE]
# coffee [FALSE]
# code [default]
# title [template name]
# main (alias for title)
# extra
# palette
# col (alias for palette)
# color_title
# file
# file_name
# dir
# link_text
# rotate_label_y
# sidebar
#' @exportClass Chart
Chart <- setRefClass("Chart",

    fields = list(
               name = "character",
               data = "ANY",
               params = "list",

               # internal
               file_structure = "list",
               config = "list",
               placeholder = "list",
               code = "character"
    ),

    methods = list(

        initialize = function(params = list()) {
            initFields(params = params)
            name <<- as.character(class(.self))

            # When a subclass of Chart gets source'd it loses the packages loaded by the standard loading process (because it belongs to a different namespace), so they must be added manually
            library(yaml)
            library(knitr)
            library(stringr)
            library(rjson)
        },

        display = function() {
            .self$get_params()
            .self$get_file_structure()
            .self$get_config()
            .self$get_data()
            .self$generate()

            do_action()
        },

        # Multiple actions may be specified as a character vector
        # If actions includes "open", it opens a new browser tab with the output file
        # If actions includes "link", it returns an HTML link (invisible)
        # If actions includes "iframe", it returns an HTML iframe (invisible)
        # If actions includes is FALSE, no action is taken.
        do_action = function(){
            if (config$require_server){
                url <- paste0("http://localhost:", port, "/", file_structure$names$output_file)
            } else {
                url <- file_structure$paths$output_file
            }

            if ("open" %in% params$action) {
                browseURL(url)
            }

            ret <- ""
            if ("iframe" %in% params$action) {
                width <- params$iframe_width %or% params$width
                height <- params$iframe_height %or% params$height

                ret <- paste(ret, make_iframe(url, width, height), sep = "\n")
            }

            if ("link" %in% params$action) {
                link_text <- params$link_text %or% params$title %or% "link"

                ret <- paste(ret, make_link(url, link_text), sep = "\n")
            }


            cat(ret)
        }

   )
)