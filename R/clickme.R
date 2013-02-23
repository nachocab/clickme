#' Ensures the data is ready for its template, converts it to JSON and writes it to a file.
#'
#'
save_data <- function(data, data_path, template_config){
    data <- prepare_data(data, template_config)
    writeLines(to_JSON(data), data_path)
}

#' Generate the HTML elements needed by the template
#'
#'
render_skeleton <- function(opts){
    knit_expand(opts$skeleton, opts = opts)
}

#' Customize the template code to the current opts, including the data
#'
#'
render_template <- function(opts){
    knit_expand(opts$template, opts = opts)
}

#' Generate the JavaScript visualization
#'
#' Write the input data.frame to a file, for easier JavaScript consumption
generate_visualization <- function(data, opts){
    save_data(data, opts$data_path, opts$template_config)
    render_skeleton(opts)
}

#' Write the output html file with the JavaScript code embedded
#'
#' we use capture.output to hide the knitr progress bars, how should we deal with errors?
save_visualization <- function(visualization, visualization_path){
    capture.output(knit2html(text = visualization, output = visualization_path))
}

#' Generates a JavaScript visualization
#'
#'
#' @export
#' @import knitr
clickme <- function(data, template_id, opts = NULL){
    if (is.null(.clickme_env$path)) clickme_path()

    opts <- populate_opts(data, template_id, opts)

    visualization <- generate_visualization(data, opts)
    save_visualization(visualization, opts$visualization_path)

    # make server and open visualization

    opts$visualization_path
}