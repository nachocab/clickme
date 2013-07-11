Chart$methods(
    generate = function(){
        get_placeholders()

        translate_coffee_template_to_js()

        html_code <- parse_placeholders()

        writeLines(html_code, file_structure$paths$output_file)

        export_assets()

    },

    get_placeholders = function(){
        placeholder <<- list()

        placeholder$spec$json <<- c("{", 2)
        placeholder$spec$plain <<- c("{", 3)
        placeholder$spec$coffee_json <<- c("[", 3)
        placeholder$spec$coffee_plain <<- c("[", 4)

        placeholder$delim$json <<- get_placeholder_delim(placeholder$spec$json)
        placeholder$delim$plain <<- get_placeholder_delim(placeholder$spec$plain)
        placeholder$delim$coffee_json <<- get_placeholder_delim(placeholder$spec$coffee_json)
        placeholder$delim$coffee_plain <<- get_placeholder_delim(placeholder$spec$coffee_plain)

        placeholder$regex$json <<- get_placeholder_regex(placeholder$spec$json)
        placeholder$regex$plain <<- get_placeholder_regex(placeholder$spec$plain)
        placeholder$regex$coffee_json <<- get_placeholder_regex(placeholder$spec$coffee_json)
        placeholder$regex$coffee_plain <<- get_placeholder_regex(placeholder$spec$coffee_plain)
    },

    # Translate the coffeescript template into a javascript template
    # The delimiter "{{" is not valid coffeescript, so we change it to an unlikely sequence "[[[\"". When the template has been converted to JS, we replace the delimiter to "{{", the one used by plain JS templates.
    # "{{ \"4\" }}" => "[[[\" \\\"4\\\" \"]]]" => knit => "{{ \"4\" }}"
    translate_coffee_template_to_js = function() {
        if (params$coffee && file.exists(file_structure$paths$template_coffee_file)){
            if (!is_coffee_installed()) {
                stop("\"coffee\" doesn't appear to be installed. Follow installation instructions at http://coffeescript.org/")
            }

            coffee_template <- readLines(file_structure$paths$template_coffee_file, warn = FALSE)
            coffee_template <- paste(coffee_template, collapse = "\n")

            replaced_coffee_template <- replace_delimiter(coffee_template, placeholder$regex$json, placeholder$delim$coffee_json, deparse = TRUE)
            replaced_coffee_template <- replace_delimiter(replaced_coffee_template, placeholder$regex$plain, placeholder$delim$coffee_plain, deparse = TRUE)

            suppressMessages(knit(text = replaced_coffee_template, output = file_structure$paths$template_file, quiet = TRUE))

            js_template <- paste(readLines(file_structure$paths$template_file), collapse = "\n")
            replaced_js_template <- replace_delimiter(js_template, placeholder$regex$coffee_json, placeholder$delim$json, deparse = FALSE)
            replaced_js_template <- replace_delimiter(replaced_js_template, placeholder$regex$coffee_plain, placeholder$delim$plain, deparse = FALSE)

            writeLines(replaced_js_template, file_structure$paths$template_file)
        }
    },

    parse_placeholders = function() {

        template <- paste0(readLines(file_structure$paths$template_file, warn = FALSE), collapse = "\n")

        locations <- str_locate_all(template, placeholder$regex$json)[[1]]
        if (nrow(locations) > 0){
            expressions <- str_extract_all(template, placeholder$regex$json)[[1]]
            expressions <- str_replace(expressions, placeholder$regex$json, "\\1")

            force_use_methods(expressions)
            expressions <- paste0("clickme::to_json(", expressions, ")")

            template <- evaluate_placeholders(expressions, template, locations)
        }

        locations <- str_locate_all(template, placeholder$regex$plain)[[1]]
        if (nrow(locations) > 0){
            expressions <- str_extract_all(template, placeholder$regex$plain)[[1]]
            expressions <- str_replace(expressions, placeholder$regex$plain, "\\1")

            force_use_methods(expressions)

            template <- evaluate_placeholders(expressions, template, locations)
        }

        template
    },

    # Only actively used methods are loaded in the environment. To avoid having to append .self in the template, something like {{ .self$my_method() }} we to load them explicitely.
    force_use_methods = function(expressions){
        methods <- extract_functions(expressions)

        # usingMethods(methods) doesn't work because it requires naming each method individually (it doesn't do anything at runtime), so we have to call .self$my_method to load it explicitly (without actually executing it).
        sapply(methods, function(method){
            tryCatch(eval(parse(text = paste0(".self$", method))), error = function(e) e)
        })
    },

    # This function needs to be a method so it can eval the Chart's fields and methods.
    evaluate_placeholders = function(expressions, template, locations) {
        placeholder_values <- sapply(expressions, function(expression) {
            eval(parse(text = expression))
        })

        template <- replace_placeholders(placeholder_values, template, locations)
        template
    },

    # Ensures that all the assets used by the visualization are copied to the output_xxx_assets path
    export_assets = function(){

        # if the clickme shared assets folder exists,
        # and either the output shared assets folder
        # doesn't exist, or
        # it was modified before (or after!) the clickme shared assets folder, rewrite everything.
        if (file.exists(file_structure$paths$shared_assets) &&
                (!file.exists(file_structure$paths$output_shared_assets) ||
                 file.info(file_structure$paths$shared_assets)$mtime != file.info(file_structure$paths$output_shared_assets)$mtime)){
            dir.create(file_structure$paths$output_shared_assets, showWarnings = FALSE)
            file.copy(from = list.files(file_structure$paths$shared_assets, full.names = TRUE), to = file_structure$paths$output_shared_assets, overwrite = TRUE)
        }

        if (file.exists(file_structure$paths$template_assets) &&
                (!file.exists(file_structure$paths$output_template_assets) ||
                 file.info(file_structure$paths$template_assets)$mtime != file.info(file_structure$paths$output_template_assets)$mtime)){
            dir.create(file_structure$paths$output_template_assets, showWarnings = FALSE)
            file.copy(from = list.files(file_structure$paths$template_assets, full.names = TRUE), to = file_structure$paths$output_template_assets, overwrite = TRUE)
        }

    }

)

# Borrowing heavily from Yihui Xie
#' @export
#' @keywords internal
replace_delimiter <- function(template, old_placeholder_regex, new_delimiter, deparse){
    locations <- str_locate_all(template, old_placeholder_regex)[[1]]
    if (nrow(locations) > 0){
        expressions <- str_extract_all(template, old_placeholder_regex)[[1]]
        expressions <- str_replace(expressions, old_placeholder_regex, "\\1")

        if (deparse){
            expressions <- unname(sapply(expressions, deparse))
        } else {
            expressions <- unname(sapply(expressions, function(x) eval(parse(text = x))))
        }

        expressions <- unname(sapply(expressions, function(x) paste0(new_delimiter[1], x, new_delimiter[2])))

        template <- replace_placeholders(expressions, template, locations)
    }

    template
}

#' @export
#' @keywords internal
replace_placeholders <- function(results, template, locations) {

    num_locations <- nrow(locations)
    for(i in 1:num_locations) {
        num_chars <- nchar(template)

        str_sub(template, locations[i, 1], locations[i, 2]) <- results[i]

        if (i < num_locations) {
            locations[(i + 1):num_locations, ] <- locations[(i + 1):num_locations, ] - (num_chars - nchar(template))
        }
    }

    template
}

#' @export
#' @keywords internal
get_placeholder_regex <- function(spec) {
    opening_symbol <- spec[1]
    num_repeats <- spec[2]

    if (opening_symbol == "{"){
        opening_symbol <- "{"
        closing_symbol <- "}"
    } else if (opening_symbol == "["){
        opening_symbol <- "\\["
        closing_symbol <- "\\]"
    }

    regex <- perl(paste0(
                  "(?<!", opening_symbol, ")",             # negative lookbehind
                  opening_symbol, "{", num_repeats, "}",   # match opening symbol exactly num_repeats times
                  "(?!", opening_symbol, ")",              # negative lookahead
                  "([^", opening_symbol, "]+)",            # match anything that isn't the opening symbol
                  "(?<!", closing_symbol, ")",             # negative lookbehind
                  closing_symbol, "{", num_repeats, "}",   # match opening symbol exactly num_repeats times
                  "(?!", closing_symbol, ")")              # negative lookahead
    )

    regex
}

#' @export
#' @keywords internal
get_placeholder_delim <- function(spec){
    opening_symbol <- spec[1]
    num_repeats <- spec[2]

    # TODO: refactor
    if (opening_symbol == "{"){
        delim <- c(paste(rep("{", num_repeats), collapse = ""), paste(rep("}", num_repeats), collapse = ""))
    } else if (opening_symbol == "["){
        delim <- c(paste(rep("[", num_repeats), collapse = ""), paste(rep("]", num_repeats), collapse = ""))
    }

    delim
}



