Chart$methods(

    # I can use Mike Bostock's lazy iframes trick by setting "data-src" instead of "src"
    iframe = function(width = NULL,
                      height = NULL,
                      src = NULL,
                      relative_path = NULL,
                      frameborder = 0){
        if (demo_mode()){
            relative_path <- relative_path %or% getOption("clickme_demo_path")
            src <- src %or% getOption("clickme_demo_iframe_src")
            height <- height %or% getOption("clickme_demo_iframe_height")
            width <- width %or% getOption("clickme_demo_iframe_width")
        }

        src <- src %or% "src"
        height <- height %or% (params$height + params$padding$top + params$padding$bottom + 40)
        width <- width %or% (params$width + params$padding$right + params$padding$left)
        url <- get_relative_url(relative_path)
        iframe <- sprintf("<iframe width=\"%d\" height=\"%d\" %s=\"%s\" frameborder=%s> </iframe>\n",
                               width,
                               height,
                               src,
                               url,
                               frameborder)
        cat(iframe)
        .self
    },

    link = function(text = params$title, class = "clickme", relative_path = NULL){
        url <- get_relative_url(relative_path)

        link <- sprintf("<a href=\"%s\" class=\"%s\">%s</a>\n", url, class, text)

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
            url <- sprintf("%s/%s", relative_path, internal$file$names$output_file)
        }

        url
    },

    # dummy function to not open the current chart
    hide = function(){
        invisible()
    }

)