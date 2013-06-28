#' @import knitr
Template$methods(
    generate_visualization = function(){
        translate_coffee_to_js()

        source(file_structure$paths$translator_file)
        html_code <- knit_expand(file_structure$paths$template_file)

        writeLines(html_code, file_structure$paths$output_file)

        export_assets()

    },

    # Translate the coffeescript template into a javascript template
    # The delimiter "{{" is not valid coffeescript, so we change it to an unlikely sequence "[[[\"". When the template has been converted to JS, we replace the delimiter to "{{", the one used by plain JS templates.
    # "{{ \"4\" }}" => "[[[\" \\\"4\\\" \"]]]" => knit => "{{ \"4\" }}"
    translate_coffee_to_js = function() {
        if (params$coffee && file.exists(file_structure$paths$template_coffee_file)){
            if (!is_coffee_installed()) {
                stop("\"coffee\" doesn't appear to be installed. Follow installation instructions at http://coffeescript.org/")
            }

            coffee_template <- readLines(file_structure$paths$template_coffee_file, warn = FALSE)
            coffee_template <- paste(coffee_template, collapse = "\n")

            coffee_delimiter <- c("[[[", "]]]")
            js_delimiter <- c("{{", "}}")
            replaced_coffee_template <- replace_delimiter(coffee_template, js_delimiter, coffee_delimiter, deparse = TRUE)

            suppressMessages(knit(text = replaced_coffee_template, output = file_structure$paths$template_file, quiet = TRUE))

            js_template <- paste(readLines(file_structure$paths$template_file), collapse = "\n")
            replaced_js_template <- replace_delimiter(js_template, coffee_delimiter, js_delimiter, deparse = FALSE)

            writeLines(replaced_js_template, file_structure$paths$template_file)
        }
    },

    # Ensures that all the assets used by the visualization are copied to the output_xxx_assets path
    export_assets = function(){

        if (file.exists(file_structure$paths$shared_assets) &&
                (!file.exists(file_structure$paths$output_shared_assets) ||
                 file.info(file_structure$paths$shared_assets)$mtime > file.info(file_structure$paths$output_shared_assets)$mtime)){
            dir.create(file_structure$paths$output_shared_assets, showWarnings = FALSE)
            file.copy(from = list.files(file_structure$paths$shared_assets, full.names = TRUE), to = file_structure$paths$output_shared_assets, overwrite = TRUE)
        }

        if (file.exists(file_structure$paths$template_assets) &&
                (!file.exists(file_structure$paths$output_template_assets) ||
                 file.info(file_structure$paths$template_assets)$mtime > file.info(file_structure$paths$output_template_assets)$mtime)){
            dir.create(file_structure$paths$output_template_assets, showWarnings = FALSE)
            file.copy(from = list.files(file_structure$paths$template_assets, full.names = TRUE), to = file_structure$paths$output_template_assets, overwrite = TRUE)
        }

    }

)

# Borrowing heavily from Yihui Xie
replace_delimiter <- function(template, old_delimiter, new_delimiter, deparse){
    old_delimiter <- gsub('([.|()\\^{}+$*?]|\\[|\\])', '\\\\\\1', old_delimiter)
    old_delimiter <- str_c(old_delimiter[1], '((.|\n)+?)', old_delimiter[2])
    locations <- str_locate_all(template, old_delimiter)[[1]]
    if (nrow(locations) > 0){
        expressions <- str_extract_all(template, old_delimiter)[[1]]
        expressions <- str_replace(expressions, old_delimiter, '\\1')
        if (deparse){
            expressions <- unname(sapply(expressions, deparse))
        } else {
            expressions <- unname(sapply(expressions, function(x) eval(parse(text = x))))
        }

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


