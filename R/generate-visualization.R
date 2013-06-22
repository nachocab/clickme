coffee_installed <- function() {
    system("coffee -v", ignore.stdout = TRUE, ignore.stderr = TRUE) == 0
}

# Borrowing heavily from Yihui's knitr code
replace_delimiter <- function(template, old_delimiter, new_delimiter, deparse){
    old_delimiter <- gsub('([.|()\\^{}+$*?]|\\[|\\])', '\\\\\\1', old_delimiter)
    old_delimiter <- str_c(old_delimiter[1], '((.|\n)+?)', old_delimiter[2])
    locations <- str_locate_all(template, old_delimiter)[[1]]
    if (nrow(locations) != 0){
        expressions <- str_extract_all(template, old_delimiter)[[1]]
        expressions <- str_replace(expressions, old_delimiter, '\\1')
        if (deparse){
            expressions <- unname(sapply(expressions, deparse))
        } else {
            expressions <- unname(sapply(expressions, function(x) eval(parse(text = x))))
        }
        # expressions <- gsub("\"", "\\\\\"", expressions)
        expressions <- unname(sapply(expressions, function(x) paste0(new_delimiter[1], " ", x, " ", new_delimiter[2])))
        num_locations <- nrow(locations)
        for (i in 1:num_locations) {
            num_chars <- nchar(template)
            str_sub(template, locations[i, 1], locations[i, 2]) <- expressions[i]
            if (i < num_locations) {
                locations[(i + 1):num_locations, ] <- locations[(i + 1):num_locations, ] - (num_chars - nchar(template))
            }
        }
    }

    template
}

# Translate the coffeescript template into a javascript template
translate_coffee <- function(opts) {
    if (opts$coffee && file.exists(opts$paths$template_coffee_file)){
        if (!coffee_installed()) {
            stop("\"coffee\" doesn't appear to be installed. Follow installation instructions at http://coffeescript.org/")
        }

        # The delimiter "{{" is not valid coffeescript, so we change it to an unlikely sequence "[[[\"". When the template has been converted to JS, we replace the delimiter to "{{" so it uses the same format as plain JS templates.
        coffee_template <- readLines(opts$paths$template_coffee_file, warn = FALSE)
        coffee_template <- paste(coffee_template, collapse = "\n")

        # "{{ \"4\" }}" => "[[[\" \\\"4\\\" \"]]]" => knit => "{{ \"4\" }}"
        coffee_delimiter <- c("[[[", "]]]")
        js_delimiter <- c("{{", "}}")
        replaced_coffee_template <- replace_delimiter(coffee_template, js_delimiter, coffee_delimiter, deparse = TRUE)

        suppressMessages(knit(text = replaced_coffee_template, output = opts$paths$template_file, quiet = TRUE))

        js_template <- paste(readLines(opts$paths$template_file), collapse = "\n")
        replaced_js_template <- replace_delimiter(js_template, coffee_delimiter, js_delimiter, deparse = FALSE)

        writeLines(replaced_js_template, opts$paths$template_file)
    }
}

#' @import knitr
generate_visualization <- function(opts){
    translate_coffee(opts)

    source(opts$paths$translator_file)
    html_code <- knit_expand(opts$paths$template_file)
    writeLines(html_code, opts$paths$output_file)
}