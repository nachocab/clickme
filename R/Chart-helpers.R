Chart$methods(

    get_url = function(){
        if (config$require_server){
            url <<- paste0("http://localhost:", port, "/", file_structure$names$output_file)
        } else {
            url <<- file_structure$paths$output_file
        }
    },

    # I can use Mike Bostock's lazy iframes trick by setting "data-src" instead of "src"
    iframe = function(width = params$width + params$padding$right + params$padding$left,
                      height = params$height + params$padding$top + params$padding$bottom + 4,
                      data_src = "src"){
        iframe <- gettextf("<iframe width = \"%d\" height = \"%d\" %s=\"%s\"> </iframe>\n",
                               width,
                               height,
                               data_src,
                               url)

        cat(iframe)
        .self
    },

    link = function(name = params$title, class = "clickme"){
        link <- gettextf("<a href=\"%s\" class=\"%s\">%s</a>\n", url, class, name)

        cat(link)
        .self
    },

    # dummy function to not open the current chart
    hide = function(){

    }

)