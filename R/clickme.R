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

#' Ensures the data is ready for its template, converts it to JSON and writes it to a file.
#'
#'
save_data <- function(data, data_path, template_config){
    data <- prepare_data(data, template_config)
    writeLines(to_JSON(data), data_path)
}

#' Generate the JavaScript visualization
#'
#' Write the input data.frame to a file, for easier JavaScript consumption
generate_visualization <- function(data, opts){
    save_data(data, opts$data_path, opts$template_config)
    render_skeleton(opts)
}

#' Set up the default paths and the custom names for the input data and the visualization file names.
#'
#' @import yaml
populate_opts <- function(data, template_id, opts) {
    opts$skeleton_path <- system.file(.clickme_env$skeleton_file_name, package="clickme")

    opts$template_path <- file.path(.clickme_env$path, .clickme_env$templates_dir_name, template_id, .clickme_env$template_file_name)
    if (!file.exists(opts$template_path)) stop("Template", template_id, "not in: ", opts$template_path)

    opts$config_path <- file.path(.clickme_env$path, .clickme_env$templates_dir_name, template_id, .clickme_env$config_file_name)
    if (file.exists(opts$config_path)){
        opts$template_config <- yaml.load_file(opts$config_path)
    }

    opts$data_name <- opts$data_name %||% paste0(deparse(substitute(data)), ".json")
    opts$data_path <- file.path(.clickme_env$path, .clickme_env$data_dir_name, opts$data_name)

    opts$viz_name <- opts$viz_name %||% paste0(deparse(substitute(data)), "_", template_id, ".html")
    opts$viz_path <- file.path(.clickme_env$path, opts$viz_name)

    opts
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

    # make server and open visualization, option interactive by default

    opts$visualization_path
}

# clickme_embed: returns code
# clickme_link: builds a link <a href>