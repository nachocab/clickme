context("clickme")

test_that("creates visualization", {
    cleanup_files(system.file("", package="clickme"), c(file.path("data", "data.json"), "data_nachocab_scatterplot.html"))

    data <- data.frame(logFC=c(1,2,3), y=c(.01,.1,.009))
    clickme_path(system.file("demo", package="clickme"))
    clickme(data, "nachocab_scatterplot")

    expect_true(file.exists(system.file(file.path("demo", .clickme_env$data_dir_name, "data.json"), package="clickme")))
    expect_true(file.exists(system.file(file.path("demo", "data_nachocab_scatterplot.html"), package = "clickme")))
})