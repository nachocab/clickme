#' Make an HTML link
#' @param url URL
#' @param name name of the link ("link" by default)
#'
#' @export
make_link <- function(url, name) {
    name <- name %||% "link"
    link <- gettextf("<a href=\"%s\" target = \"_blank\">%s</a>\n\n", url, name)
    cat(link)
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
        message <- gettextf("There are duplicated elements in your groups:\n%s", paste(duplicated_elements, collapse = "\n"))
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

#' Validates colorize
#'
#' @param params parameters
#'
#' @export
validate_colorize <- function(params) {
    if (scale_type(params$colorize) == "categorical" & !is.null(params$color_domain)){
        stop("A color domain can only be specified for quantitative scales. colorize has categorical values.")
    }

    palette_names <- names(params$palette)
    categories <- unique(params$colorize)
    if (!is.null(params$colorize) & !is.null(params$palette) & !is.null(palette_names)) {
        if (scale_type(params$colorize) == "categorical"){
            if (any(categories %notin% palette_names)){
                stop("The following categories don't have a color in palette: ", paste0(categories[categories %notin% palette_names], collapse = ", "))
            }
            if (any(palette_names %notin% categories)) {
                stop("The following palette names don't appear in colorize: ", paste0(palette_names[palette_names %notin% categories], collapse = ", "))
            }
        } else {
            stop("The values in colorize imply a quantitative scale, which requires an unnamed vector of the form c(start_color[, middle_color], end_color)")
        }
    }
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

#' Reorder data by color
#'
#' @param data data
#' @param params parameters
#'
#' It adds a colorize column and it uses it to reorder the data object. This ensures that rows are ordered in a way that elements with the first color in the palette are rendered on top
#'
#' @export
reorder_data_by_color <- function(data, params){
    data$colorize <- params$colorize

    if (!is.null(names(params$palette))){
        category_order <- unlist(sapply(names(params$palette), function(category) {
            which(data$colorize == category)
        }))
        data <- data[rev(category_order),]
    } else {
        data <- data[order(data$colorize, decreasing = TRUE),]
    }

    data
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
                       "#1f77b4", # blue
                       "#d62728", # red
                       "#9467bd", # purple
                       "#ff7f0e", # orange
                       "#2ca02c", # green
                       "#17becf", # cyan
                       "#e377c2", # pink
                       "#7f7f7f",
                       "#bcbd22"
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

#' Get padding around plot
#'
#' @param opts ractive options
#' @param default default padding, a vector with top, left, bottom and right values
#'
#' @export
get_padding_param <- function(opts, default = c(top = 100, right = 100, bottom = 100, left = 100)) {
    if (is.null(opts$params$padding)){
        opts$params$padding <- default
    }

    library(rjson)
    padding <- opts$params$padding

    if (length(padding) != 4){
        stop("Please provide four padding values. (currently ", paste(padding, collapse=", "), ")")
    }

    if (is.null(names(padding))) {
        names(padding) <- c("top", "right", "bottom", "left")
    }

    padding <- toJSON(padding)

    padding
}

#' Generate HTML style and script tags
#'
#' @param opts the options of the current template
#' @export
get_external <- function(opts){
    styles_and_scripts <- paste0(c(get_styles(opts), get_scripts(opts)), collapse="\n")
    styles_and_scripts
}

#' Generate HTML script tags
#'
#' @param opts the options of the current template
#' @export
get_scripts <- function(opts) {
    scripts <- paste(sapply(opts$config$scripts, function(script_path){
        if (!grepl("^http", script_path)){
            script_path <- file.path(opts$relative_path$external, script_path)
        }
        paste0("<script src=\"", script_path, "\"></script>")
    }), collapse="\n")

    scripts
}

#' Generate HTML style tags
#'
#' @param opts the options of the current template
#' @export
get_styles <- function(opts) {
    styles <- paste(sapply(opts$config$styles, function(style_path){
        if (!grepl("^http", style_path)){
            style_path <- file.path(opts$relative_path$external, style_path)
        }
        paste0("<link href=\"", style_path, "\" rel=\"stylesheet\">")
    }), collapse="\n")

    styles
}

#' Create a data file
#'
#' Creates a file in the ractive data directory
#'
#' @param opts the options of the current template
#' @param extension the extension of the file
#' @param sep the character used to separate fields in each line of the file ("," by default)
#' @param method function used to generate the file (".csv" uses "write.csv" by default, every other file extension uses "writeLines")
#' @param row_names show row names when using \code{write.csv}
#' @param relative_path boolean indicating if the path to the file should be relative or absolute
#' @param quote_escaped boolean indicating if the file name should be surrounded with escaped quotes.
#' @param ... arguments passed to the function specified by method
#' @export
create_data_file <- function(opts, extension, sep=",", method = NULL, row_names = FALSE, relative_path = TRUE, quote_escaped = TRUE, ...) {
    if (!grepl("^\\.", extension)) extension <- paste0(".", extension)

    data_file_name <- paste0(opts$data_prefix, extension)
    data_file_path <- file.path(opts$path$data, data_file_name)
    relative_data_file_path <- file.path(opts$relative_path$data, data_file_name)

    if ((is.null(method) && extension == ".csv") || (!is.null(method) && method == "write.csv")){
        write.csv(opts$data, file = data_file_path, row.names = row_names,...)
    } else {
        writeLines(text = opts$data, con = data_file_path, ...)
    }
    message("Created data file at: ", data_file_path)

    if (relative_path){
        path <- relative_data_file_path
    } else {
        path <- data_file_path
    }

    if (quote_escaped){
        path <- quote_escaped(path)
    }

    path
}

#' Read a ractive's CSV file
#'
#'
#'
#' @param ractive ractive name
#' @param file_name CSV file name
#' @export
read_ractive_csv <- function(ractive, file_name) {
    opts <- get_opts(ractive)
    data <- read.csv(file.path(opts$path$data, file_name))

    data
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

source_dir <- function(path){
    sapply(list.files(path), function(file){
        source(file.path(path, file))
    })
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
server <- function(path = get_templates_path(), port = 8000){
    system(paste0("cd ", path, "; python -m SimpleHTTPServer ", port))
    message("Server running at ", path)
}

#' Test the translator of a given ractive
#'
#' @param ractive name of ractive
#' @export
test_ractive <- test_translator <- function(ractive){
    opts <- get_opts(ractive)

    if (file.exists(opts$path$translator_test_file)){
        library("testthat")
        source(opts$path$translator_file)
        test_file(opts$path$translator_test_file)
    } else {
        stop(paste0("There is no test translator file at this location: ", opts$path$translator_test_file, "\nYou might have to create it or call set_templates_path()"))
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

#' Show which ractives are available
#'
#' @export
list_ractives <- function() {
    message("Available ractives at: ", get_templates_path())
    write(plain_list_ractives(), "")
}

plain_list_ractives <- function() {
    basename(list.dirs(get_templates_path(), recursive = F))
}


#' @import stringr
titleize <- function(str){
    str <- str_replace(str,"_"," ")
    words_in_str <- strsplit(str, " ")[[1]]
    title <- paste0(toupper(substring(words_in_str, 1, 1)), substring(words_in_str, 2), collapse=" ")
    names(title) <- NULL
    title
}

#' Open an HTML file in the browser
#'
#' By default it will open \code{get_opts(ractive)$url}
#'
#' @param ractive ractive name
#' @param ... additional fields for \code{get_opts}
#' @export
open_html <- function(ractive, ...) {
    opts <- get_opts(ractive, ...)
    browseURL(opts$url)
}

open_all_html <- function(){
    for (ractive in plain_list_ractives()){
        open_html(ractive)
    }
}

open_all_demos <- function(){
    for (ractive in plain_list_ractives()){
        demo_ractive(ractive)
    }
}

#' Get information about a ractive
#'
#' @param ractive ractive name
#' @param fields any of the fields in config.yml
#' @export
show_ractive <- function(ractive, fields = NULL){

    opts <- get_opts(ractive)

    fields <- fields %||% names(opts$config)

    message("Ractive")
    cat(ractive, "\n\n")

    for (field in fields){
        if (!is.null(opts$template[[field]])){
            if (field == "params") {
                if (length(opts$config$params) > 0){
                    message(paste0(titleize(field)))
                    cat(paste0(paste0(names(opts$config$params), ": ", opts$config$params), collapse="\n"), "\n\n")
                }
            } else if (field == "data_names") {
                if (length(opts$config$data_names$required) > 0){
                    message(paste0(titleize(field)))
                    cat(paste0(c("Required:", opts$config$data_names$required), collapse=" "), "\n")
                }
                if (length(opts$config$data_names$optional) > 0){
                    message(paste0(titleize(field)))
                    cat(paste0(c("Optional:", opts$config$data_names$optional), collapse=" "), "\n")
                }
                cat ("\n")
            } else {
                message(paste0(titleize(field)))
                cat(paste0(opts$config[[field]], collapse="\n"), "\n\n")
            }
        }
    }

    cat("\n")
}

#' Run a ractive demo
#'
#' @param ractive name of ractive
#' @export
demo_ractive <- function(ractive) {
    opts <- get_opts(ractive)
    if (is.null(opts$config$demo)){
        message("The ", ractive, " ractive didn't provide a demo example.")
    } else {
        message("Getting ready to run the following demo for the ", ractive, " ractive:\n\n", opts$config$demo)
        message("\nPress Enter to continue or \"c\" to cancel: ", appendLF = FALSE)
        response <- readline()
        if (tolower(response) %in% c("c")) {
            message("Demo was canceled.")
        } else {
            eval(parse(text = opts$config$demo))
        }
    }
}


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
    expected_path <- file.path(opts$path$data, paste0(test_data_prefix, extension))
    expect_true(file.exists(expected_path))
    if (!is.null(expected_data)){
        expect_equal(readContents(expected_path), expected_data)
    }
    unlink(expected_path)
}
