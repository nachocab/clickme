context("clickme")

test_that("uses default templates", {

    # ensure that these don't exist before testing
    file.remove(file.path(system.file(file.path("data","data.json"), package = "clickme")))
    file.remove(file.path(system.file(file.path("data_nachocab_scatterplot.html"), package = "clickme")))

    data <- data.frame(logFC=c(1,2,3), y=c(.01,.1,.009))
    clickme(data, "nachocab_scatterplot")
    expect_true(system.file(file.path("data","data.json"), package = "clickme"))
    expect_true(system.file(file.path("data_nachocab_scatterplot.html"), package = "clickme"))

})

# TODO: don't overwrite existing data.json files
# TODO: creates a server
# TODO: embed or link