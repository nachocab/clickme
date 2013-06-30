Clickme <- setRefClass("Clickme",

    contains = "Template",

    methods = list(

        templates = function(){
            dir(getOptions("clickme_templates_path"))
        }

    )

)

clickme <- Clickme$new()