context("clickme")

test_that("error when the template doesn't exist", {
    data <- data.frame(logFC=c(1,2,3), y=c(.01,.1,.009))
    expect_error(clickme(data, "nachocab_scatterplot"))
})

test_that("creates visualization", {
    # cleanup_files(system.file("", package="clickme"), c(file.path("data", "data.json"), "data_nachocab_scatterplot.html"))
    data <- data.frame(logFC=c(1,2,3), y=c(.01,.1,.009))
    expect_error(clickme(data, "nachocab_scatterplot"))

    # expect_true(system.file(file.path("data","data.json"), package = "clickme"))
    # expect_true(system.file(file.path("data_nachocab_scatterplot.html"), package = "clickme"))
})

# TODO: don't overwrite existing data.json files
# TODO: creates a server
# TODO: embed or link