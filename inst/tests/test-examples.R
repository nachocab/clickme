context("examples")

test_that("the HTML example file for the force_directed ractive is generated", {
    set_root_path(system.file("examples", package="clickme"))
    ractive <- "force_directed"

    # we do this to ensure that the HTML file doesn't exist before we create it
    opts <- get_opts(ractive, data_name = "data")
    unlink(opts$path$html_file)
    data <- read.csv(file.path(opts$path$data, "original_data.csv"))

    html_file_path <- clickme(data, ractive, data_name = "data", browse=FALSE)

    expect_true(file.exists(opts$path$html_file))
})

test_that("the HTML example file for the line_with_focus ractive is generated", {
    set_root_path(system.file("examples", package="clickme"))
    ractive <- "line_with_focus"

    # we do this to ensure that the HTML file doesn't exist before we create it
    opts <- get_opts(ractive, data_name = "data")
    unlink(opts$path$html_file)
    data <- read.csv(file.path(opts$path$data, "original_data.csv"))

    html_file_path <- clickme(data, ractive, data_name = "data", browse=FALSE)

    expect_true(file.exists(opts$path$html_file))
})

test_that("the HTML example file for the longitudinal_heatmap ractive is generated", {
    set_root_path(system.file("examples", package="clickme"))
    ractive <- "longitudinal_heatmap"

    # we do this to ensure that the HTML file doesn't exist before we create it
    opts <- get_opts(ractive, data_name = "data")
    unlink(opts$path$html_file)
    data <- read.csv(file.path(opts$path$data, "original_data.csv"))

    html_file_path <- expect_message(clickme(data, ractive, data_name = "data", browse=FALSE), "Make sure you have a server running at")

    expect_true(file.exists(opts$path$html_file))
})

test_that("the HTML example file for the one_zoom ractive is generated", {
    set_root_path(system.file("examples", package="clickme"))
    ractive <- "one_zoom"

    # we do this to ensure that the HTML file doesn't exist before we create it
    opts <- get_opts(ractive, data_name = "data")
    unlink(opts$path$html_file)
    data <- file.path(opts$path$data, "mammals.tree")

    html_file_path <- clickme(data, ractive, data_name = "data", browse=FALSE)

    expect_true(file.exists(opts$path$html_file))
})

context("example translators")
test_that("example translators work", {
    set_root_path(system.file("examples", package="clickme"))

    for(ractive in plain_list_ractives()){
        test_translator(ractive)
    }
})
