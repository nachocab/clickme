#' Return a C-style format given the type of data
#'
#' It also allows to set a custom format
#'
#' @export
#' @keywords internal
get_formats <- function(data, custom_formats = NULL){
    custom_format_names <- names(custom_formats)
    formats <- sapply(colnames(data), function(name) {
        if (name %in% custom_format_names){
            custom_formats[[name]]
        } else {
            x <- data[, name]
            if (is.numeric(x) && any(x %% 1 != 0)) {
                ".2f"
            } else {
                "s"
            }
        }
    })

    formats
}

#' Extract function names from a list of placeholder expressions
#' @export
#' @keywords internal
extract_functions <- function(expressions){
    functions <- as.character(na.omit(str_match(expressions, "^\\s*(([[:alpha:]]|[.][._[:alpha:]])[._[:alnum:]]*)\\(.+|\\n\\)")[,2]))
    functions
}

#' Title Case
#' @export
title_case <- function(strings){
    first_letter <- toupper(substring(strings, 1, 1))
    everything_else <- substring(strings, 2, nchar(strings))
    title_case <- paste0(first_letter, everything_else)
    title_case
}

#' Convert to CamelCase
#' @export
camel_case <- function(strings){
    strings <- gsub("_", ".", strings)
    strings <- strsplit(strings, "\\.")
    strings <- sapply(strings, title_case, simplify = FALSE)
    camel_case <- sapply(strings, paste, collapse = "")
    camel_case
}

#' Convert to snake_case
#' @export
snake_case <- function(strings){
    strings <- gsub("^[^[:alnum:]]+|[^[:alnum:]]+$", "", strings)
    strings <- gsub("(?!^)(?=[[:upper:]])", " ", strings, perl = TRUE)
    strings <- strsplit(tolower(strings), " ")
    snake_case <- sapply(strings, paste, collapse = "_")
    snake_case
}

#' @export
is.valid <- function(x){
    !is.na(x) & !is.nan(x) & !is.infinite(x)
}

separator <- function(n = 70){
    paste0(rep("=", n, collapse = ""))
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
move_in_front <- function(first_elements, all_elements) {
    if (any(first_elements %notin% all_elements)){
        stop(gettextf("\n\n\tThe following elements don't appear in \"%s\":\n%s\n",
             deparse(substitute(all_elements)),
             enumerate(first_elements[any(first_elements %notin% all_elements)])))
    }
    all_elements <- all_elements[c(which(all_elements %in% first_elements), which(all_elements %notin% first_elements))]
    all_elements
}

error_title <- function(message){
    paste0("\n\n*** ", message, " ***\n\n")
}

#' Return the elements of a character vector separated by newlines
#'
#' @export
enumerate <- function(x) {
    paste0("\t", x, collapse = "\n")
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
        message <- gettextf("\n\tThe following elements appear in more than one group:\n%s", paste(duplicated_elements, collapse = "\n"), "\n")
        if (strict_dups){
            stop(message)
        } else {
            message(message)
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


#' Classify the elements of a vector into Venn categories
#' @export
vennize <- function(a, b, only_in_a = "Only in A", only_in_b = "Only in B", in_both = "In both") {
    results <- list()
    results[[only_in_a]] <- setdiff(a,b)
    results[[in_both]] <- intersect(a,b)
    results[[only_in_b]] <- setdiff(b,a)

    results
}

percentage <- function(x){
    x/sum(x)*100
}

#' Return the levels of a factor, or the unique elements of a character vector
#' @param elements values
#' @export
get_unique_elements <- function(elements) {
    if (is.factor(elements)){
        unique_elements <- levels(elements)
    } else {
        unique_elements <- unique(elements)
    }

    unique_elements <- na.omit(unique_elements)
    unique_elements
}

#' Remove whitespace from a string
#'
#'
no_whitespace <- function(str){
    gsub("\\s","", str)
}

#' Sample with replacement
#'
#' @export
sample_r <- function(input, n){
    sample(input, n, replace = TRUE)
}

#' Type of scale
#'
#' @param elements values
#'
#' If elements is numeric and has a length greater than one, it returns "quantitative". If elements is NULL, or not numeric, or has a length of one, it returns "categorical".
#'
#' @export
scale_type <- function(elements) {
    if (!is.null(elements) && is.numeric(elements) && length(elements) > 1){
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
                       "#ff7f0e", # orange
                       "#9467bd", # purple
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
#' d <- a %or% b # d == "a"
#' a <- NULL
#' d <- a %or% b # d == "b"
"%or%" <- function(a, b) {
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
test_template <- function(template_name, filter = NULL){
    template <- Chart$new()
    template$internal$file$names$template <- camel_case(template_name)
    template$get_default_names_and_paths()

    if (file.exists(template$internal$file$paths$translator_test_file)){
        library("testthat")
        reload_translators()
        env <- new.env()
        with_envvar(r_env_vars(), test_dir(template$internal$file$paths$tests, filter = filter, env = env))
    } else {
        stop(gettextf("\n\n\tThere is no test translator file at this location:\n\n%s",
                       template$internal$file$paths$translator_test_file))
    }
}

source_dir <- function(path){
    # This order ensures that Points.R comes before Points-helper.R
    files <- sort(list.files(path, full.names = TRUE), decreasing = TRUE)
    sapply(files, source)
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
#     opts$config <- yaml.load_file(internal$file$paths$config_file)
#     if (is.null(opts$internal$config$demo)){
#         message("The ", template, " template didn't provide a demo example.")
#     } else {
#         message("Running demo for the ", template, " template:\n\n", opts$internal$config$demo)
#         eval(parse(text = opts$internal$config$demo))
#     }
# }




#' @export
is_character_or_factor <- function(x) {
    is.character(x) || is.factor(x)
}

#' @export
is_data_frame_or_matrix <- function(x) {
    is.data.frame(x) || is.matrix(x)
}


