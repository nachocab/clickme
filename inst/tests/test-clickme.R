context("clickme")

test_that("creates visualization", {
    set_root_path(system.file("examples", package="clickme"))
    ractive <- "force_directed"
    opts <- get_opts(ractive, data_file_name = "data")
    cleanup_files(path=opts$path$viz_file)

    data <- read.csv(file.path(opts$path$data, "lawsuits.txt"))
    viz_file_path <- clickme(data, "force_directed", data_file_name = "data", browse=FALSE)

    expect_equal(viz_file_path, opts$path$viz_file)
    expect_true(file.exists(opts$path$viz_file))

    scripts <- append_scripts(opts)
    expect_equal(scripts[1], paste0("<script src=\"", file.path(opts$relative_path$external, opts$template_config$scripts[1]), "\"></script>"))

    styles <- append_styles(opts)
    expect_equal(styles[1], paste0("<link href=\"", file.path(opts$relative_path$external, opts$template_config$styles[1]), "\" rel=\"stylesheet\">"))
})



