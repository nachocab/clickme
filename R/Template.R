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
# colorize
# color_domain
# color_title
# file
# file_name
# dir
#' @export
Template <- setRefClass("Template",

    fields = c(
               "params",
               "file_structure",
               "config",
               "data",
               "name",
               "placeholder"
    ),

    methods = list(

        initialize = function(params = list()) {
            initFields(params = params)
            name <<- as.character(class(.self))

            # I'm adding them explicitly because when a subclass of Template gets source'd it loses the clickme namespace
            library(yaml)
            library(knitr)
            library(stringr)
            library(rjson)

            return()
        },

        get_data = function(){
            data <<- params$data
        },

        display = function() {

            .self$get_params()
            .self$get_file_structure()
            .self$get_config()
            .self$get_data()
            .self$generate_visualization()

            do_action()

        },

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
            if ("link" %in% params$action) {
                ret <- paste(ret, make_link(url, params$title %||% "link"), sep = "\n")
            }

            if ("iframe" %in% params$action) {
                ret <- paste(ret, make_iframe(url, params$width, params$height, params$frameborder), sep = "\n")
            }

            invisible(ret)
        }

   )
)