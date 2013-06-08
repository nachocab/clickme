library(yaml)

context("default path and names")

test_that("clickme_templates_path exists", {
    old_clickme_templates_path <- getOption("clickme_templates_path")

    options("clickme_templates_path" = "fake_clickme_templates_path")
    opts <- get_default_paths("fake_template")
    expect_error(validate_paths(opts), gettextf("doesn't contain a valid path: %s", "fake_clickme_templates_path"))

    options("clickme_templates_path" = old_clickme_templates_path)
})

test_that("default path and name variables are assigned", {
    opts <- get_default_paths("test_template")

    expect_equal(opts$path$template, file.path(getOption("clickme_templates_path"), "test_template"))
    expect_equal(opts$path$template_assets, file.path(opts$path$template, "assets"))
    expect_equal(opts$path$clickme_assets, file.path(getOption("clickme_output_path"), "clickme_assets"))

    expect_equal(opts$path$template_file, file.path(opts$path$template, "template.Rmd"))
    expect_equal(opts$path$config_file, file.path(opts$path$template, "config.yml"))
    expect_equal(opts$path$translator_file, file.path(opts$path$template, "translator.R"))
    expect_equal(opts$path$translator_test_file, file.path(opts$path$template, "test-translator.R"))

    expect_equal(opts$relative_path, "clickme_assets")
})

test_that("default paths are valid", {
    old_paths <- list(templates = getOption("clickme_templates_path"), output = getOption("clickme_output_path"))
    options("clickme_output_path" = system.file("output", package = "clickme"))
    options("clickme_templates_path" = system.file("templates", package = "clickme"))

    opts <- get_default_paths("fake_template")

    expect_error(validate_paths(opts), gettextf("There is no template fake_template located in: %s", file.path(getOption("clickme_templates_path"), "fake_template")) )
    dir.create(opts$path$template)

    expect_error(validate_paths(opts), gettextf("The fake_template template doesn't contain a template file in: %s", opts$path$template_file))
    file.create(opts$path$template_file)

    expect_error(validate_paths(opts), gettextf("The fake_template template doesn't contain a configuration file in: %s", opts$path$config_file))
    file.create(opts$path$config_file)

    expect_error(validate_paths(opts), gettextf("The fake_template template doesn't contain a translator file in: %s", opts$path$translator_file))
    file.create(opts$path$translator_file)

    unlink(opts$path$template, recursive = TRUE)
    options("clickme_templates_path" = old_paths$templates)
    options("clickme_output_path" = old_paths$output)

})

test_that("clickme_output_path is created when it doesn't exist", {
    old_clickme_output_path <- getOption("clickme_output_path")

    options("clickme_output_path" = file.path(system.file(package = "clickme"), "output_test"))
    opts <- get_default_paths("fake_template")
    dir.create(opts$path$template)
    sapply(c(opts$path$template_file, opts$path$translator_file, opts$path$config_file), file.create)

    validate_paths(opts)
    expect_true(file.exists(system.file("output_test", package = "clickme")))

    unlink(system.file("output_test", package = "clickme"), recursive = TRUE)
    unlink(opts$path$template, recursive = TRUE)
    options("clickme_output_path" = old_clickme_output_path)
})

test_that("clickme_output_path goes back to default when NULL", {
    old_clickme_output_path <- getOption("clickme_output_path")

    options("clickme_output_path" = NULL)
    opts <- get_default_paths("fake_template")
    dir.create(opts$path$template)
    sapply(c(opts$path$template_file, opts$path$translator_file, opts$path$config_file), file.create)
    expect_warning(validate_paths(opts), gettextf("was NULL. Using: %s", system.file("output", package = "clickme")))

    unlink(opts$path$template, recursive = TRUE)
    options("clickme_output_path" = old_clickme_output_path)
})


context("validate assets")

test_that("styles and scripts must be valid", {
    test_path <- file.path(system.file("output", package = "clickme"), "test")
    dir.create(test_path)
    opts <- list(path=list(template_assets = test_path))

    opts$config$styles <- c("abc.css")
    expect_error(validate_assets(opts), "abc.css not found")

    file.create(file.path(test_path, "abc.css"))
    expect_true({validate_assets(opts); TRUE})

    opts$config$scripts <- c("abc.js")
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
#     expect_equal(opts$name$html_file, paste0(opts$data_prefix, "-", opts$name$template, ".html"))
#     expect_equal(opts$path$html_file, file.path(getOption("clickme_templates_path"), opts$name$html_file))
# })

# test_that("name_mappings gets saved", {
#     name_mappings <- c(my_source = "source")
#     opts <- get_opts("force_directed", name_mappings = name_mappings)
#     expect_equal(opts$name_mappings, name_mappings)
# })

# test_that("opts$url is set", {
#     expect_equal(opts$url, opts$path$html_file)

#     opts <- get_opts("par_coords")
#     expect_equal(opts$url, "http://localhost:8000/data-par_coords.html")
# })

# test_that("user params override template params", {
#     opts <- get_opts("force_directed", params = list(height = 666))
#     expect_equal(opts$params$height, 666)
# })
