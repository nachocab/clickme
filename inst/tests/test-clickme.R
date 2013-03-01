context("clickme")

test_that("creates local visualization", {
    cleanup_files(system.file("", package="clickme"), "data-force_directed_local.html")

    data <- read.csv(system.file(file.path("demo", "templates", "force_directed_local", "data", "lawsuits.txt"), package="clickme"))
    clickme_path(system.file("demo", package="clickme"))
    path$viz <- clickme(data, "force_directed_local", opts=list(name$data_file="data"), browse=FALSE)

    expect_equal(system.file(file.path("demo", "data-force_directed_local.html"), package = "clickme"), path$viz)
    expect_true(file.exists(system.file(file.path("demo", "data-force_directed_local.html"), package = "clickme")))
})

test_that("creates server visualization", {
    cleanup_files(system.file("", package="clickme"), "data-force_directed_server.html")

    data <- read.csv(system.file(file.path("demo", "templates", "force_directed_server", "data", "lawsuits.txt"), package="clickme"))
    clickme_path(system.file("demo", package="clickme"))
    path$viz <- clickme(data, "force_directed_server", opts=list(name$data_file="data"), browse=FALSE)

    expect_equal("data-force_directed_server.html", path$viz)
    expect_true(file.exists(system.file(file.path("demo", "data-force_directed_server.html"), package = "clickme")))
})

