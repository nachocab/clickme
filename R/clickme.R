TEMPLATES_PATH <- "/Users/nacho/Documents/Code/my_knitr_reports/d3/templates/"
get_template_path <- function(template){
    paste0(TEMPLATES_PATH, template,".Rmd")
}

#' Generates an interactive plot
#' @export
#' @import knitr
clickme <- function(data, template, path = ".", opts = list(width=800, height=500)){
    data_path <- file.path(path, "data.json")
    JSON_data <- to_JSON(prepare_for_template(data))
    message("writing: ",data_path)
    writeLines(JSON_data, data_path)

    template_path <- get_template_path(template)

    # TODO: consigue que importe knitr, devtools check seems to overwrite NAMESPACEm
    .blank_env <- new.env()
    .blank_env$src <- knit_expand(template_path, data="data.json", plot_width = opts$width, plot_height = opts$height)

    blank_interactive_path <- "/Users/nacho/Documents/Code/my_knitr_reports/d3/blank_d3.Rmd"
    knit2html(blank_interactive_path, output="/Users/nacho/Documents/Code/my_knitr_reports/d3/paco.html")

    # make server and return url?

}