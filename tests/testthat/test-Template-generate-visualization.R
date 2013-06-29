context("Template-generate-visualization")

test_that("placeholders", {

    delim <- get_placeholder_delim(c("{", 2))
    expect_equal(delim, c("{{", "}}"))

    delim <- get_placeholder_delim(c("[", 2))
    expect_equal(delim, c("[[", "]]"))

    regex <- get_placeholder_regex(c("{", 2))
    expect_equal(regex, perl("(?<!{){{2}(?!{)([^{]+)(?<!})}{2}(?!})"))

    regex <- get_placeholder_regex(c("[", 2))
    expect_equal(regex, perl("(?<!\\[)\\[{2}(?!\\[)([^\\[]+)(?<!\\])\\]{2}(?!\\])"))

    matches <- str_extract_all("{{}} {{ 1 }} {{{ 2 }}} {{3}}", get_placeholder_regex(c("{", 2)))[[1]]
    expect_equal(matches, c("{{ 1 }}", "{{3}}"))

    matches <- str_extract_all("{{}} {{ 1 }} {{{ 2 }}} {{3}}", get_placeholder_regex(c("{", 3)))[[1]]
    expect_equal(matches, c("{{{ 2 }}}"))

    matches <- str_extract_all("[[]] [[ 1 ]] [[[ 2 ]]] [[3]]", get_placeholder_regex(c("[", 2)))[[1]]
    expect_equal(matches, c("[[ 1 ]]", "[[3]]"))

    matches <- str_extract_all("[[]] [[ 1 ]] [[[ 2 ]]] [[3]]", get_placeholder_regex(c("[", 3)))[[1]]
    expect_equal(matches, c("[[[ 2 ]]]"))

})

TestTemplate <- setRefClass('TestTemplate', contains = "Template", where=.GlobalEnv)
test_template_path <- file.path(getOption("clickme_templates_path"), "testtemplate")
dir.create(test_template_path)
file.create(file.path(test_template_path, "template.Rmd"))
file.create(file.path(test_template_path, "config.yml"))
file.create(file.path(test_template_path, "translator.R")) # Todo: remove this requirement

test_output_dir <- file.path(system.file("output", package = "clickme"), "test")
dir.create(test_output_dir)
test_output_file <- file.path(test_output_dir, "test.html")

test_that("replace_delimiter", {

    test_template <- TestTemplate$new()
    test_template$get_placeholders()
    placeholder <- test_template$placeholder

    text <- "a = {{ a }}"
    converted_text <- replace_delimiter(text,
                                        placeholder$regex$json,
                                        placeholder$delim$coffee_json,
                                        deparse = TRUE)
    expect_equal(converted_text, "a = [[[\" a \"]]]")

    text <- "a = {{a}}"
    converted_text <- replace_delimiter(text,
                                        placeholder$regex$json,
                                        placeholder$delim$coffee_json,
                                        deparse = TRUE)
    expect_equal(converted_text, "a = [[[\"a\"]]]")

    text <- "a = {{ \"a\" }}"
    converted_text <- replace_delimiter(text,
                                        placeholder$regex$json,
                                        placeholder$delim$coffee_json,
                                        deparse = TRUE)
    expect_equal(converted_text, "a = [[[\" \\\"a\\\" \"]]]")

    text <- "{{ a }} {{ b }} {{ c }}"
    converted_text <- replace_delimiter(text,
                                        placeholder$regex$json,
                                        placeholder$delim$coffee_json,
                                        deparse = TRUE)
    expect_equal(converted_text, "[[[\" a \"]]] [[[\" b \"]]] [[[\" c \"]]]")

    text <- "a = {{ a %||% \"b\" }}"
    converted_text <- replace_delimiter(text,
                                        placeholder$regex$json,
                                        placeholder$delim$coffee_json,
                                        deparse = TRUE)
    expect_equal(converted_text, "a = [[[\" a %||% \\\"b\\\" \"]]]")

    text <- "a = {{{ a }}}"
    converted_text <- replace_delimiter(text,
                                        placeholder$regex$plain,
                                        placeholder$delim$coffee_plain,
                                        deparse = TRUE)
    expect_equal(converted_text, "a = [[[[\" a \"]]]]")

    text <- "a = [[[ \" \\\"a\\\" \" ]]]"
    converted_text <- replace_delimiter(text,
                                        placeholder$regex$coffee_json,
                                        placeholder$delim$json,
                                        deparse = FALSE)
    expect_equal(converted_text, "a = {{ \"a\" }}")

    text <- "a = [[[[ \" a \" ]]]]"
    converted_text <- replace_delimiter(text,
                                        placeholder$regex$coffee_plain,
                                        placeholder$delim$plain,
                                        deparse = FALSE)
    expect_equal(converted_text, "a = {{{ a }}}")

})



test_that("regular templates are rendered", {

    test_template <- TestTemplate$new(list(a = 3, b = "b", c = "my_function(3)", file = test_output_file))
    test_template$get_params()
    test_template$get_file_structure()

    writeLines("
<script type=\"text/javascript\">
    var a = {{ params$a }};
    var b = {{ params$b }};
    var c = {{{ params$c }}};
</script>", test_template$file_structure$paths$template_file)

    test_template$generate_visualization()

    rendered_contents <- readContents(test_template$file_structure$paths$output_file)
    expected_contents <- "
<script type=\"text/javascript\">
    var a = 3;
    var b = \"b\";
    var c = my_function(3);
</script>"
    expect_equal(rendered_contents, expected_contents)

})

test_that("coffee templates are rendered", {

    test_template <- TestTemplate$new(list(a = 3, b = "b", c = "my_function(3)", coffee = TRUE, file = test_output_file))
    test_template$get_params()
    test_template$get_file_structure()

    writeLines("
<script type=\"text/javascript\">
```{r engine=\"coffee\", results=\"asis\", echo = FALSE }
    a = {{ params$a }}
    b = {{ params$b }}
    c = {{{ params$c }}}
```
</script>", test_template$file_structure$paths$template_coffee_file)

    test_template$generate_visualization()

    rendered_template <- readContents(test_template$file_structure$paths$template_file)
    expected_template <- "
<script type=\"text/javascript\">
(function() {
  var a, b, c;

  a = {{ params$a }};

  b = {{ params$b }};

  c = {{{ params$c }}};

}).call(this);

</script>"
    expect_equal(rendered_template, expected_template)

    rendered_output <- readContents(test_template$file_structure$paths$output_file)
    expected_output <- "
<script type=\"text/javascript\">
(function() {
  var a, b, c;

  a = 3;

  b = \"b\";

  c = my_function(3);

}).call(this);

</script>"
    expect_equal(rendered_output, expected_output)

})

# test_that("export_assets updates output shared and output template assets", {

#     test_template <- TestTemplate$new()
#     test_template$get_params()
#     test_template$get_file_structure()
#     test_template$get_config()

#     test_template$config$styles <- c("abc.css", "$shared/def.css", "http://somefile.css")

#     dir.create(test_template$file_structure$paths$template_assets)
#     template_asset_path <- file.path(test_template$file_structure$paths$template_assets, "abc.css")
#     file.create(template_asset_path)
#     shared_asset_path <- file.path(test_template$file_structure$paths$shared_assets, "def.css")
#     file.create(shared_asset_path)

#     test_template$export_assets()
#     expect_true(file.exists(template_asset_path))
#     expect_true(file.exists(shared_asset_path))

#     unlink(shared_asset_path)
# })

unlink(test_template_path, recursive = TRUE)
unlink(test_output_dir, recursive = TRUE)
