context("clickme")

test_that("creates force_directed visualization", {
    set_root_path(system.file("examples", package="clickme"))
    ractive <- "force_directed"
    opts <- get_opts(ractive, data_file_name = "data.csv")
    cleanup_files(path=opts$path$viz_file)

    data <- read.csv(file.path(opts$path$data, "lawsuits.txt"))
    viz_file_path <- clickme(data, ractive, data_file_name = "data.csv", browse=FALSE)

    expect_equal(viz_file_path, opts$path$viz_file)
    expect_true(file.exists(opts$path$viz_file))

    scripts <- append_scripts(opts)
    expect_equal(scripts[1], paste0("<script src=\"", file.path(opts$relative_path$external, opts$template_config$scripts[1]), "\"></script>"))

    # URL paths are not modified
    opts$template_config$scripts <- "http://mbostock.github.com/d3/d3.js"
    scripts <- append_scripts(opts)
    expect_equal(scripts[1], paste0("<script src=\"http://mbostock.github.com/d3/d3.js\"></script>"))

    styles <- append_styles(opts)
    expect_equal(styles[1], paste0("<link href=\"", file.path(opts$relative_path$external, opts$template_config$styles[1]), "\" rel=\"stylesheet\">"))

    opts$template_config$styles <- "http://mbostock.github.com/d3/d3.css"
    styles <- append_styles(opts)
    expect_equal(styles[1], paste0("<link href=\"http://mbostock.github.com/d3/d3.css\" rel=\"stylesheet\">"))
})

test_that("creates line_with_focus visualization", {
    set_root_path(system.file("examples", package="clickme"))
    ractive <- "line_with_focus"
    opts <- get_opts(ractive, data_file_name = "data.csv")
    cleanup_files(path=opts$path$viz_file)

    data <- read.csv(file.path(opts$path$data, "data.csv"))
    viz_file_path <- clickme(data, ractive, data_file_name = "data.csv", browse=FALSE)

    expect_equal(viz_file_path, opts$path$viz_file)
    expect_true(file.exists(opts$path$viz_file))
})

test_that("creates longitudinal_heatmap visualization", {
    set_root_path(system.file("examples", package="clickme"))
    ractive <- "longitudinal_heatmap"
    opts <- get_opts(ractive, data_file_name = "data.csv")
    cleanup_files(path=opts$path$viz_file)

    data <- read.csv(file.path(opts$path$data, "original_data.csv"))
    viz_file_path <- clickme(data, ractive, data_file_name = "data.csv", browse=FALSE, validate_names=FALSE)

    expect_equal(viz_file_path, opts$path$viz_file)
    expect_true(file.exists(opts$path$viz_file))
})



