context("clickme")

test_that("creates visualization", {
    set_root_path(system.file("demo", package="clickme"))
    template_id <- "force_directed"
    opts <- get_opts(template_id, data_file_name = "data")
    cleanup_files(path=opts$path$viz_file)

    data <- read.csv(file.path(opts$path$data, "lawsuits.txt"))
    viz_path <- clickme(data, "force_directed", data_file_name = "data", browse=FALSE)

    expect_equal(viz_path, opts$path$viz_file)
    expect_true(file.exists(opts$path$viz_file))
})

test_that("creates local server visualization", {
    set_root_path(system.file("demo", package="clickme"))
    template_id <- "force_directed_local_server"
    opts <- get_opts(template_id, data_file_name = "data")
    cleanup_files(path=opts$path$viz_file)

    data <- read.csv(file.path(opts$path$data, "lawsuits.txt"))
    viz_path <- clickme(data, "force_directed_local_server", data_file_name="data", browse=FALSE)

    expect_equal(viz_path, opts$name$viz_file)
    expect_true(file.exists(opts$path$viz_file))
})

