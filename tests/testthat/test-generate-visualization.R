context("generate_visualization")

test_dir <- file.path(system.file("output", package = "clickme"), "test")
dir.create(test_dir)

test_that("regular templates are rendered", {
    unlink(file.path(test_dir, "*"), recursive = TRUE)
    opts <- list()
    opts$coffee <- FALSE
    opts$paths$translator_file <- file.path(system.file("templates", package ="clickme"), "points", "translator.R")
    opts$paths$template_file <- file.path(test_dir, "test.Rmd")
    opts$paths$output_file <- file.path(test_dir, "test.html")

    opts$params$a <- 3
    writeLines("
<script type=\"text/javascript\">
    var a = {{ opts$params$a }};
</script>", opts$path$template_file)

    generate_visualization(opts)
    rendered_contents <- readContents(opts$paths$output_file)
    expected_contents <- "
<script type=\"text/javascript\">
    var a = 3;
</script>"
    expect_equal(rendered_contents, expected_contents)

    unlink(opts$paths$template_file)
    unlink(opts$paths$output_file)
})

test_that("replace_delimiter", {
    js_delimiter <- c("{{", "}}")
    coffee_delimiter <- c("[[[", "]]]")

    text <- "a = {{ a }}"
    converted_text <- replace_delimiter(text, js_delimiter, coffee_delimiter, deparse = TRUE)
    expect_equal(converted_text, "a = [[[ \" a \" ]]]")

    text <- "a = {{a}}"
    converted_text <- replace_delimiter(text, js_delimiter, coffee_delimiter, deparse = TRUE)
    expect_equal(converted_text, "a = [[[ \"a\" ]]]")

    text <- "a = {{ \"a\" }}"
    converted_text <- replace_delimiter(text, js_delimiter, coffee_delimiter, deparse = TRUE)
    expect_equal(converted_text, "a = [[[ \" \\\"a\\\" \" ]]]")

    text <- "{{ a }} {{ b }} {{ c }}"
    converted_text <- replace_delimiter(text, js_delimiter, coffee_delimiter, deparse = TRUE)
    expect_equal(converted_text, "[[[ \" a \" ]]] [[[ \" b \" ]]] [[[ \" c \" ]]]")

    text <- "a = {{ a %||% \"b\" }}"
    converted_text <- replace_delimiter(text, js_delimiter, coffee_delimiter, deparse = TRUE)
    expect_equal(converted_text, "a = [[[ \" a %||% \\\"b\\\" \" ]]]")

    text <- "a = [[[ \" \\\"a\\\" \" ]]]"
    converted_text <- replace_delimiter(text, coffee_delimiter, js_delimiter, deparse = FALSE)
    expect_equal(converted_text, "a = {{  \"a\"  }}")

})

test_that("coffee templates are rendered", {

    opts <- list()
    opts$coffee <- TRUE
    opts$paths$template_file <- file.path(test_dir, "test.Rmd")
    opts$paths$template_coffee_file <- file.path(test_dir, "test.coffee.Rmd")
    opts$paths$translator_file <- file.path(system.file("templates", package ="clickme"), "points", "translator.R")
    opts$paths$output_file <- file.path(test_dir, "test.html")

    opts$params$a <- 3
    writeLines("
<script type=\"text/javascript\">
```{r engine=\"coffee\", results=\"asis\", echo = FALSE }
    a = {{ opts$params$a }}
    b = {{ toJSON(\"4\") }}
    c = {{ opts$params$d %||% toJSON(\"b\") }}
```
</script>", opts$paths$template_coffee_file)

    generate_visualization(opts)
    rendered_template <- readContents(opts$paths$template_file)
    expected_template <- "\n<script type=\"text/javascript\">\n(function() {\n  var a, b, c;\n\n  a = {{  opts$params$a  }};\n\n  b = {{  toJSON(\"4\")  }};\n\n  c = {{  opts$params$d %||% toJSON(\"b\")  }};\n\n}).call(this);\n\n</script>"
    expect_equal(rendered_template, expected_template)

    rendered_output <- readContents(opts$paths$output_file)
    expected_output <- "\n<script type=\"text/javascript\">\n(function() {\n  var a, b, c;\n\n  a = 3;\n\n  b = \"4\";\n\n  c = \"b\";\n\n}).call(this);\n\n</script>"
    expect_equal(rendered_output, expected_output)

    # TODO: allow something like this: a = {{ opts$params$a %||% \"b\" }}

})

unlink(test_dir, recursive = TRUE)