# params:
# x
# y [NULL]
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
Template <- setRefClass('Template',

    fields = c(
               "params",
               "file_structure",
               "config",
               "data"
    ),

    methods = list(

        initialize = function(params = list()) {
            initFields(params = params)
            get_params()
        },

        display = function() {

            generate_visualization()

            if (config$require_server){
                url <- paste0("http://localhost:", port, "/", file_structure$names$output_file)
            } else {
                url <- file_structure$paths$output_file
            }

            if (open) browseURL(url)

            if (link){
                make_link(url, params$title)
            }
        }
   )
)