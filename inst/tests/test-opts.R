library(yaml)

context("opts: names and paths")

test_that("default paths are added", {
    opts <- get_default_opts("test_template")
    expect_equal(opts$paths$template, file.path(getOption("clickme_templates_path"), "test_template"))
    expect_equal(opts$paths$template_assets, file.path(opts$paths$template, "assets"))

    expect_equal(opts$paths$template_file, file.path(opts$paths$template, "template.Rmd"))
    expect_equal(opts$paths$config_file, file.path(opts$paths$template, "config.yml"))
    expect_equal(opts$paths$translator_file, file.path(opts$paths$template, "translator.R"))
    expect_equal(opts$paths$translator_test_file, file.path(opts$paths$template, "test-translator.R"))

})


test_that("output file name is added", {
    opts <- get_default_opts("test_template")

    opts <- add_output_file_name(opts, file = NULL, file_name = NULL)
    expect_equal(opts$names$output_file, "temp-test_template.html")

    opts <- add_output_file_name(opts, file = file.path("my_folder", "my_file.html"), file_name = NULL)
    expect_equal(opts$names$output_file, "my_file.html")

    opts <- add_output_file_name(opts, file = file.path("my_folder", "my_file"), file_name = NULL)
    expect_equal(opts$names$output_file, "my_file.html")

    opts <- add_output_file_name(opts, file = NULL, file_name = "my_file.html")
    expect_equal(opts$names$output_file, "my_file.html")

    opts <- add_output_file_name(opts, file = NULL, file_name = "my_file")
    expect_equal(opts$names$output_file, "my_file.html")

    expect_warning(opts <- add_output_file_name(opts, file = file.path("my_folder", "my_file1.html"), file_name = "my_file2.html"), "The \"file_name\" argument was ignored because the \"file\" argument was present: ")
    expect_equal(opts$names$output_file, "my_file1.html")
})

test_that("output paths are added", {
    opts <- get_default_opts("test_template")

    opts <- add_output_file_name(opts, file = NULL, file_name = NULL)
    opts <- add_output_paths(opts, file = NULL, dir = NULL)
    expect_equal(opts$paths$output, system.file("output", package = "clickme"))
    expect_equal(opts$paths$output_file, file.path(opts$paths$output, opts$names$output_file))

    expect_equal(opts$paths$shared_assets, file.path(getOption("clickme_templates_path"), "__shared_assets"))
    expect_equal(opts$paths$output_template_assets, file.path(opts$path$output, "clickme_assets", "test_template"))
    expect_equal(opts$paths$output_shared_assets, file.path(opts$path$output, "clickme_assets"))

    expect_equal(opts$relative_path$template_assets, file.path("clickme_assets", "test_template"))
    expect_equal(opts$relative_path$shared_assets, "clickme_assets")

    opts <- add_output_file_name(opts, file = NULL, file_name = NULL)
    opts <- add_output_paths(opts, file = NULL, dir = "my_folder")
    expect_equal(opts$paths$output, "my_folder")
    expect_equal(opts$paths$output_file, file.path(opts$paths$output, opts$names$output_file))

    opts <- add_output_file_name(opts, file = file.path("my_folder", "my_file1.html"), file_name = NULL)
    opts <- add_output_paths(opts, file = file.path("my_folder", "my_file1.html"), dir = NULL)
    expect_equal(opts$paths$output, "my_folder")
    expect_equal(opts$paths$output_file, file.path(opts$paths$output, opts$names$output_file))

    opts <- add_output_file_name(opts, file = file.path("my_folder1", "my_file1.html"), file_name = NULL)
    expect_warning(opts <- add_output_paths(opts, file = file.path("my_folder1", "my_file1.html"), dir = "my_folder2"), "The \"dir\" argument was ignored because the \"file\" argument was present: ")
    expect_equal(opts$paths$output, "my_folder1")
    expect_equal(opts$paths$output_file, file.path(opts$paths$output, opts$names$output_file))
})

test_that("default paths and are valid", {

    opts <- get_default_opts("test_template")
    opts <- add_output_file_name(opts, file = NULL, file_name = NULL)
    opts <- add_output_paths(opts, file = NULL, dir = NULL)

    expect_error(validate_paths(opts), gettextf("There is no template test_template located in: %s", file.path(getOption("clickme_templates_path"), "test_template")) )

    dir.create(opts$paths$template)
    expect_error(validate_paths(opts), gettextf("The test_template template doesn't contain a template file in: %s", opts$paths$template_file))

    file.create(opts$paths$template_file)
    expect_error(validate_paths(opts), gettextf("The test_template template doesn't contain a configuration file in: %s", opts$paths$config_file))

    file.create(opts$paths$config_file)
    expect_error(validate_paths(opts), gettextf("The test_template template doesn't contain a translator file in: %s", opts$paths$translator_file))

    file.create(opts$paths$translator_file)
    expect_true({validate_paths(opts); TRUE})

    dir_path <- file.path(system.file("output", package = "clickme"), "output_test")
    opts <- add_output_paths(opts, file = NULL, dir = dir_path)
    opts <- add_paths(opts)
    validate_paths(opts)
    expect_true(file.exists(dir_path))
    unlink(file.path(system.file("output", package = "clickme"), "output_test"), recursive = TRUE)

    unlink(opts$path$template, recursive = TRUE)
})

context("opts: validate assets")

test_that("styles and scripts must be valid", {
    test_path <- file.path(system.file("output", package = "clickme"), "test_assets")
    dir.create(test_path)
    opts <- list(paths = list(template_assets = test_path, shared_assets = test_path))

    opts$config$styles <- NULL
    expect_true({validate_assets(opts); TRUE})

    opts$config$styles <- c("abc.css")
    expect_error(validate_assets(opts), "abc.css not found")
    file.create(file.path(test_path, "abc.css"))
    expect_true({validate_assets(opts); TRUE})

    opts$config$scripts <- c("$shared/abc.js")
    expect_error(validate_assets(opts), "abc.js not found")
    file.create(file.path(test_path, "abc.js"))
    expect_true({validate_assets(opts); TRUE})

    opts$config$scripts <- c("http://d3js.org/d3.v3.min.js")
    expect_true({validate_assets(opts); TRUE})

    unlink(test_path, recursive = TRUE)
})

# test_that("require_server and require_coffeescript are false by default", {
#     template <- "par_coords"
#     opts <- get_opts(template, data_prefix = "data")

#     opts$config$require_server <- NULL
#     expect_false(validate_template(opts)$config$require_server)
# })

# test_that("data_prefix is data by default, and it appends random string when NULL", {
#     opts <- validate_paths("force_directed")
#     expect_equal(opts$data_prefix, "data")

#     opts <- get_opts("force_directed", data_prefix = NULL)
#     expect_match(opts$data_prefix, "data[0-9a-z]+")
# })

# opts <- get_opts("force_directed")
# test_that("the output HTML file is named using the data_prefix and the template name", {
#     expect_equal(opts$names$html_file, paste0(opts$data_prefix, "-", opts$names$template, ".html"))
#     expect_equal(opts$paths$output_file, file.path(getOption("clickme_templates_path"), opts$names$html_file))
# })

# test_that("name_mappings gets saved", {
#     name_mappings <- c(my_source = "source")
#     opts <- get_opts("force_directed", name_mappings = name_mappings)
#     expect_equal(opts$name_mappings, name_mappings)
# })

# test_that("opts$url is set", {
#     expect_equal(opts$url, opts$paths$output_file)

#     opts <- get_opts("par_coords")
#     expect_equal(opts$url, "http://localhost:8000/data-par_coords.html")
# })

# test_that("user params override template params", {
#     opts <- get_opts("force_directed", params = list(height = 666))
#     expect_equal(opts$params$height, 666)
# })
