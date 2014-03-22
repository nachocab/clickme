
Lines <- setRefClass("Lines",

    contains = "Chart",

    methods = list(

        get_data = function(){
            data <<- params$x
        }

    )
)

clickme_helper$lines <- function(x,...){
    params <- list(x = x, ...)
    lines <- Lines$new(params)

    lines$display()
}


