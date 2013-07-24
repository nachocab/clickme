Chart$methods(

    # I can use Mike Bostock's lazy iframes trick by setting "data-src" instead of "src"
    iframe = function(width = params$width + params$padding$right + params$padding$left,
                      height = params$height + params$padding$top + params$padding$bottom + 4,
                      data_src = "src",
                      relative_path = NULL){

        url <- get_relative_url(relative_path)

        iframe <- gettextf("<iframe width = \"%d\" height = \"%d\" %s=\"%s\"> </iframe>\n",
                               width,
                               height,
                               data_src,
                               url)

        cat(iframe)
        .self
    },

    link = function(name = params$title, class = "clickme", relative_path = NULL){

        url <- get_relative_url(relative_path)

        link <- gettextf("<a href=\"%s\" class=\"%s\">%s</a>\n", url, class, name)

        cat(link)
        .self
    },

    # dummy function to not open the current chart
    hide = function(){
        invisible()
    }

)