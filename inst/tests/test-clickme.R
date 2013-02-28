context("clickme")

test_that("creates visualization", {
    cleanup_files(system.file("", package="clickme"), c(file.path("data", "data.json"), "data-force_directed.html"))

    data <- read.csv(system.file(file.path("demo", "templates", "force_directed", "data", "lawsuits.txt"), package="clickme"))
    clickme_path(system.file("demo", package="clickme"))
    clickme(data, "force_directed", opts=list(data_name="data"))

    expect_true(file.exists(system.file(file.path("demo", "data-force_directed.html"), package = "clickme")))
})

