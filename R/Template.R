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
Template <- setRefClass('Template',

    fields = c(
               "params",
               "file_structure",
               "config",
               "data",
               "name"
    ),

    methods = list(

        initialize = function(params = list()) {
            initFields(params = params)
            name <<- tolower(as.character(class(.self))) # TODO: change this to snake case
            return()
        },

        get_data = function(){
            data <<- params$data
        },

        display = function() {

            get_params()

            get_file_structure()

            get_config()

            get_data()

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