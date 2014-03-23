Chart$methods(

    # We keep this so dummy examples work, but this method is usually overloaded
    # by the template that inherits it
    get_data = function(){
        data <<- params$x
    }

)