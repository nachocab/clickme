context("examples")

test_that("the html example file for the force_directed ractive is generated", {
    set_root_path()
    ractive <- "force_directed"
    data <- read.csv(system.file("examples", "ractives", ractive, "data", "original_data.csv", package="clickme"))
    clickme(data, ractive, data_file_name = "data", browse=FALSE)
})

test_that("the html example file for the line_with_focus ractive is generated", {
    set_root_path()
    ractive <- "line_with_focus"
    data <- read.csv(system.file("examples", "ractives", ractive, "data", "original_data.csv", package="clickme"))
    clickme(data, ractive, data_file_name = "data", browse=FALSE)
})

test_that("the html example file for the longitudinal_heatmap ractive is generated", {
    set_root_path()
    ractive <- "longitudinal_heatmap"
    data <- read.csv(system.file("examples", "ractives", ractive, "data", "original_data.csv", package="clickme"))
    clickme(data, ractive, data_file_name = "data", browse=FALSE)
})