# params:
# data
# height [default]
# width [default]
# padding [default]
# box [FALSE]
# coffee [FALSE]
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
# rotate_ylab
# sidebar
# iframe_width
# iframe_height
#' @exportClass Chart
Chart <- setRefClass("Chart",

    fields = list(
        data = "ANY",
        params = "list",
        internal = "list"
    ),

    methods = list(

        initialize = function(params = list()) {
            initFields(params = params)

            internal$file$names$template <<- as.character(class(.self))

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
            .self$get_urls()
            .self$get_data()
            .self$generate()
            .self
        },

        show = function(){
            if (interactive()){
                if (internal$config$require_server){
                    browseURL(internal$url$server)
                } else {
                    browseURL(internal$url$local)
                }
            }
            .self
        }

   )
)