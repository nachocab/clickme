
#' @export
is.valid <- function(x){
    !is.na(x) & !is.nan(x) & !is.infinite(x)
}

#' Make an HTML link
#' @param url URL
#' @param name name of the link ("link" by default)
#'
#' @export
make_link <- function(url, name) {
    if (is.null(url)) {
        stop ("Please provide a valid output_file")
    }
    link <- gettextf("<a href=\"%s\" target = \"_blank\">%s</a>\n\n", url, name)
    cat(link)
}

#' Make an HTML iframe
#' @param url URL
#' @param width
#'
#' @export
make_iframe <- function(url, width, height, frameborder) {
    if (is.null(url)) {
        stop ("Please provide a valid output_file")
    }

    iframe <- gettextf("<iframe width = \"%d\" height = \"%d\" src=\"%s\" frameborder=\"%d\"> </iframe>\n\n", width, height, url, frameborder)
    cat(iframe)
}

separator <- function(n = 70){
    paste0(rep("=", n, collapse = ""))
}

#' Get the parameters passed along to a helper function
#' @export
extract_params <- function() {
    # TODO: T and F don't work, warn or try to fix
    named_params <- as.list(parent.frame())
    dots <- as.list(substitute(list(...), parent.frame()))[-1]
    params <- c(named_params, dots)
    params
}

#' Split up two vectors into their intersecting sets
#' @param a first vector
#' @param b second vector
#'
#' It returns a list of three elements, those that are only in a, those that are in both, and those that are only in b.
#'
#' @export
disjoint_sets <- function(a, b, names = c("a", "b", "both")) {
    sets <- list(setdiff(a,b), setdiff(b,a), intersect(a,b))
    names(sets) <- names
    sets
}

# move elements to the front of an array
move_in_front <- function(in_front, everything_else) {
    everything_else <- everything_else[c(which(everything_else %in% in_front), which(everything_else %notin% in_front))]
    everything_else
}

error_title <- function(message){
    paste0("\n\n*** ", message, " ***\n\n")
}

enumerate <- function(array) {
    paste("\t", array, collapse = "\n")
}

#' Match elements to groups
#' @param subset vector of elements
#' @param groups list of groups
#' @param replace_nas how to handle elements that don't appear in any of the groups. If a string is provided, it uses it as a new group for these elements.
#' @param strict_dups how to handle elements that appear in multiple groups. By default, the first matching group is reported and a warning is issued. If TRUE, it raises an error.
#'
#' It returns the name of the group where each element in the subset appears. If not in any group, it combines them into the "other " group (intentional space, in case "other" exists)
#'
#' @export
match_to_groups <- function(subset, groups, replace_nas = "Other", strict_dups = FALSE) {
    if (any(duplicated(unlist(groups)))){
        duplicated_elements <- unname(unlist(groups)[duplicated(unlist(groups))])
        message <- gettextf("The following elements appear in more than one group:\n%s", paste(duplicated_elements, collapse = "\n"))
        if (strict_dups){
            stop(message)
        } else {
            warning(message)
        }
    }

    group_ranges <- cumsum(c(1, sapply(groups, length)))
    match_indexes <- match(subset, unlist(groups))
    group_indexes <- findInterval(match_indexes, group_ranges)
    group_names <- names(groups)[group_indexes]

    if (!is.null(replace_nas)){
        group_names[is.na(group_names)] <- replace_nas
    }

    group_names
}




#' Type of scale
#'
#' @param elements values
#'
#' If elements is numeric and has a length greater than one, it returns "quantitative". If elements is NULL, or not numeric, or has a length of one, it returns "categorical".
#'
#' @export
scale_type <- function(elements = NULL) {
    if (!is.null(elements) & is.numeric(elements) & length(elements) > 1){
        type <- "quantitative"
    } else {
        type <- "categorical"
    }

    type
}



#' Default colors
#'
#' @param n number of colors
#'
#' @export
default_colors <- function(n = 9){
    # too similar purples: "#9467bd", "#8c564b"
    retro_tulips <- c(
      "#0F808C", # blue
      "#6C8C26", # green
      "#F2A71B", # orange
      "#F26A1B", # dark orange
      "#D91818" # red
    )

    set3 <- c(
        "#FB8072", # red
        "#80B1D3", # blueish
        "#B3DE69", # green
        "#FDB462", # orange
        "#8DD3C7", # teal green
        "#FFFFB3", # yellow
        "#BEBADA", # grey
        "#FCCDE5", # salmon
        "#D9D9D9" # lightgrey
    )

    d3_category9 <- c(
                       "#24A5F9", # blue
                       "#d62728", # red
                       "#9467bd", # purple
                       "#ff7f0e", # orange
                       "#3CCB23", # green
                       "#E027E4", # pink
                       "#5711AC", # plum
                       "#bcbd22" # pale olive
                       )
    # d3_category10 <- c("#1f77b4", "#d62728", "#2ca02c", "#ff7f0e", "#9467bd", "#17becf", "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22")
    d3_category19 <- c(d3_category9, "#aec7e8","#ffbb78","#98df8a","#ff9896","#c5b0d5","#c49c94","#f7b6d2","#c7c7c7","#dbdb8d","#9edae5")
    # d3_category10b <- c("#aec7e8", "#ffbb78", "#98df8a", "#ff9896", "#c5b0d5", "#c49c94", "#f7b6d2", "#c7c7c7", "#dbdb8d", "#9edae5")
    if (n <= 9){
        colors <- d3_category9[1:n]
    } else if (n <= 19) {
        colors <- d3_category19
    } else {
        colors <- rainbow(n)
    }
    colors
}

#' @export
is_coffee_installed <- function() {
    system("coffee -v", ignore.stdout = TRUE, ignore.stderr = TRUE) == 0
}

readContents <- function(path) {
    paste(readLines(path, warn = FALSE), collapse = "\n")
}

#' Inverse Value Matching
#'
#' Complement of \code{\%in\%}. Returns the elements of \code{a} that are not in \code{b}.
#' @usage a \%notin\% b
#' @param a a vector
#' @param b a vector
#' @export
#' @rdname notin
"%notin%" <- function(a, b) {
    !(a %in% b)
}

#' Set default value
#'
#' If a is not null, return a. Otherwise, return b.
#' @usage a \%||\% b
#' @param a an object
#' @param b an object
#' @export
#' @rdname nulldefault
#' @examples
#' a <- "a"
#' b <- "b"
#' d <- a %||% b # d == "a"
#' a <- NULL
#' d <- a %||% b # d == "b"
"%||%" <- function(a, b) {
  if (!is.null(a)) a else b
}

is.installed <- function(package) {
    is.element(package, installed.packages()[,1])
}

#' Surround with escaped quotes
#'
#' @param data object to surround with escaped quotes
#' @export
quote_escaped <- function(data) {
    paste0("\"", data, "\"")
}

#' Run a local server
#'
#' @param path path where server is started
#' @param port port used to start the server
#' @export
server <- function(path = getOption("clickme_templates_path"), port = 8000){
    system(paste0("cd ", path, "; python -m SimpleHTTPServer ", port))
    message("Server running at ", path)
}

#' Test the translator of a given template
#'
#' @param template name of template
#' @export
test_template <- test_translator <- function(template){
    opts <- get_opts(template)

    if (file.exists(file_structure$paths$translator_test_file)){
        library("testthat")
        source(file_structure$paths$translator_file)
        test_file(file_structure$paths$translator_test_file)
    } else {
        stop(paste0("There is no test translator file at this location: ", file_structure$paths$translator_test_file, "\nYou might have to create it or call set_templates_path()"))
    }
}

mat <- function(elements = NULL, num_elements = nrow*ncol, nrow = 5, ncol = 2, scale_by = 100, rownames = NULL, colnames = NULL){
    if (is.null(elements)){
        elements <- runif(num_elements) * scale_by
    }
    if (!is.null(ncol)){
        mat <- matrix(elements, ncol = ncol, byrow = T)
    } else {
        mat <- matrix(elements, nrow = nrow, byrow = T)
    }

    if (!is.null(rownames)) rownames(mat) <- rownames
    if (!is.null(colnames)) colnames(mat) <- colnames

    mat
}

#' Show which templates are available
#'
#' @export
list_templates <- function() {
    message("Available templates at: ", getOption("clickme_templates_path"))
    write(plain_list_templates(), "")
}

plain_list_templates <- function() {
    basename(list.dirs(getOption("clickme_templates_path"), recursive = F))
}


titleize <- function(str){
    str <- str_replace(str,"_"," ")
    words_in_str <- strsplit(str, " ")[[1]]
    title <- paste0(toupper(substring(words_in_str, 1, 1)), substring(words_in_str, 2), collapse=" ")
    names(title) <- NULL
    title
}

#' Open an HTML file in the browser
#'
#' By default it will open \code{get_opts(template)$url}
#'
#' @param template template name
#' @param ... additional fields for \code{get_opts}
#' @export
open_html <- function(template, ...) {
    opts <- get_opts(template, ...)
    browseURL(opts$url)
}

open_all_html <- function(){
    for (template in plain_list_templates()){
        open_html(template)
    }
}

open_all_demos <- function(){
    for (template in plain_list_templates()){
        demo_template(template)
    }
}

#' Run a template demo
#'
#' @param template name of template
# demo_template <- function(template) {
#     opts <- get_default_opts(template)
#     opts$config <- yaml.load_file(file_structure$paths$config_file)
#     if (is.null(opts$config$demo)){
#         message("The ", template, " template didn't provide a demo example.")
#     } else {
#         message("Running demo for the ", template, " template:\n\n", opts$config$demo)
#         eval(parse(text = opts$config$demo))
#     }
# }


#' Test generated file
#'
#' Test that the path exists, and that the contents are as expected
#'
#' @param opts options
#' @param extension extension of the file
#' @param expected_data data that should be stored in the test file.
#' @param test_data_prefix value used on the \code{get_opts(..., data_prefix = test_data_prefix)} call. It is "test_data" by default.
#' @export
expect_correct_file <- function(opts, extension, expected_data = NULL, test_data_prefix = "test_data") {
    if (!grepl("^\\.", extension)) extension <- paste0(".", extension)

    expected_relative_path <- paste("\"", file.path(opts$relative_path$data, paste0(test_data_prefix, extension)), "\"")
    expected_path <- file.path(file_structure$paths$data, paste0(test_data_prefix, extension))
    expect_true(file.exists(expected_path))
    if (!is.null(expected_data)){
        expect_equal(readContents(expected_path), expected_data)
    }
    unlink(expected_path)
}

#' @export
is_character_or_factor <- function(x) {
    is.character(x) || is.factor(x)
}

#' @export
is_data_frame_or_matrix <- function(x) {
    is.data.frame(x) || is.matrix(x)
}


