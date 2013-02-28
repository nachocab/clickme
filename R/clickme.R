#' Customize the template code to the current opts, including the data
#'
#'
render_template <- function(opts){
    knit_expand(opts$template_path, opts = opts)
}

#' Writes the data to a file for more efficient JavaScript processing
#'
#'
save_data <- function(data, data_path, template_config){
    data <- prepare_data(data, template_config)
    writeLines(data, data_path)
}

#' Generate the JavaScript visualization
#'
#' Write the input data.frame to a file, for easier JavaScript consumption
#' we use capture.output to hide the knitr progress bars, how should we deal with errors?
generate_visualization <- function(data, opts){
    save_data(data, opts$data_path, opts$template_config)
    expanded_skeleton <- knit_expand(opts$skeleton_path, opts = opts)
    capture.output(knit2html(text = expanded_skeleton, output = opts$viz_path))
}

#' Generates a JavaScript visualization
#'
#'
#' @export
#' @import knitr
clickme <- function(data, template_id, opts = NULL){
    if (is.null(.clickme_env$path)) clickme_path()

    opts <- populate_opts(data, template_id, opts)

    generate_visualization(data, opts)

    # make server and open visualization, option interactive by default

    opts$viz_path
}

# clickme_embed: returns code
# clickme_link: builds a link <a href>