Chart$methods(

    # I can use Mike Bostock's lazy iframes trick by setting "data-src" instead of "src"
    iframe = function(width = params$width + params$padding$right + params$padding$left,
                      height = params$height + params$padding$top + params$padding$bottom + 40,
                      data_src = "src",
                      frameborder = 0,
                      relative_path = NULL){

        url <- get_relative_url(relative_path)

        iframe <- gettextf("<iframe width=\"%d\" height=\"%d\" %s=\"%s\" frameborder=%s> </iframe>\n",
                               width,
                               height,
                               data_src,
                               url,
                               frameborder)

        cat(iframe)
        .self
    },

    link = function(text = params$title, class = "clickme", relative_path = NULL){

        url <- get_relative_url(relative_path)

        link <- gettextf("<a href=\"%s\" class=\"%s\">%s</a>\n", url, class, text)

        cat(link)
        .self
    },

    # internal
    get_urls = function(){
        internal$url$local <<- internal$file$paths$output_file
        internal$url$server <<- paste0("http://localhost:", params$port, "/", internal$file$names$output_file)
    },

    # internal
    get_relative_url = function(relative_path){
        if (is.null(relative_path)){
            url <- internal$file$names$output_file
        } else {
            url <- gettextf("%s/%s", relative_path, internal$file$names$output_file)
        }

        url
    },

    # dummy function to not open the current chart
    hide = function(){
        invisible()
    }

)