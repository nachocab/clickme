context("examples")

test_that("the HTML example file for the force_directed ractive is generated", {
    set_root_path(system.file("examples", package="clickme"))
    ractive <- "force_directed"

    # we do this to ensure that the HTML file doesn't exist before we create it
    opts <- get_opts(ractive)
    unlink(opts$path$html_file)
    data <- read.csv(file.path(opts$path$data, "original_data.csv"))

    clickme(data, ractive, browse = FALSE)

    expect_true(file.exists(opts$path$html_file))
})

test_that("the HTML example file for the line_with_focus ractive is generated", {
    set_root_path(system.file("examples", package="clickme"))
    ractive <- "line_with_focus"

    # we do this to ensure that the HTML file doesn't exist before we create it
    opts <- get_opts(ractive)
    unlink(opts$path$html_file)
    data <- read.csv(file.path(opts$path$data, "original_data.csv"))

    clickme(data, ractive, browse = FALSE)

    expect_true(file.exists(opts$path$html_file))
})

test_that("the HTML example file for the longitudinal_heatmap ractive is generated", {
    set_root_path(system.file("examples", package="clickme"))
    ractive <- "longitudinal_heatmap"

    # we do this to ensure that the HTML file doesn't exist before we create it
    opts <- get_opts(ractive)
    unlink(opts$path$html_file)
    data <- read.csv(file.path(opts$path$data, "original_data.csv"))

    expect_message(clickme(data, ractive, browse = FALSE), "Make sure you have a server running at")

    expect_true(file.exists(opts$path$html_file))
})

test_that("the HTML example file for the one_zoom ractive is generated", {
    set_root_path(system.file("examples", package="clickme"))
    ractive <- "one_zoom"

    # we do this to ensure that the HTML file doesn't exist before we create it
    opts <- get_opts(ractive)
    unlink(opts$path$html_file)
    data <- file.path(opts$path$data, "mammals.tree")

    clickme(data, ractive, browse = FALSE)

    expect_true(file.exists(opts$path$html_file))
})

test_that("the HTML example file for the par_coords ractive is generated", {
    set_root_path(system.file("examples", package="clickme"))
    ractive <- "par_coords"

    # we do this to ensure that the HTML file doesn't exist before we create it
    opts <- get_opts(ractive)
    unlink(opts$path$html_file)
    data <- read.csv(file.path(opts$path$data, "original_data.csv"))

    clickme(data, ractive, browse = FALSE)

    expect_true(file.exists(opts$path$html_file))
})

test_that("the HTML example file for the vega ractive is generated", {
    set_root_path(system.file("examples", package="clickme"))
    ractive <- "vega"

    # we do this to ensure that the HTML file doesn't exist before we create it
    spec <- "area"
    opts <- get_opts(ractive, params = list(spec = spec))
    unlink(opts$path$html_file)
    data <- read.csv(file.path(opts$path$data, "area_bar_scatter.csv"))

    opts <- clickme_vega(data, spec, browse = FALSE)
    expect_true(file.exists(opts$path$html_file))

    spec <- "bar"
    opts <- get_opts(ractive, params = list(spec = spec))
    unlink(opts$path$html_file)
    data <- read.csv(file.path(opts$path$data, "area_bar_scatter.csv"))

    opts <- clickme_vega(data, spec, browse = FALSE)
    expect_true(file.exists(opts$path$html_file))

    spec <- "scatter"
    opts <- get_opts(ractive, params = list(spec = spec))
    unlink(opts$path$html_file)
    data <- read.csv(file.path(opts$path$data, "area_bar_scatter.csv"))

    opts <- clickme_vega(data, spec, browse = FALSE)
    expect_true(file.exists(opts$path$html_file))

    spec <- "stocks"
    opts <- get_opts(ractive, params = list(spec = spec))
    unlink(opts$path$html_file)
    stocks <- read.csv(file.path(opts$path$data, "stocks.csv"))

    opts <- clickme_vega(stocks, spec, browse = FALSE)
    expect_true(file.exists(opts$path$html_file))

    spec <- "lifelines"
    opts <- get_opts(ractive, params = list(spec = spec))
    unlink(opts$path$html_file)
    people <- read.csv(file.path(opts$path$data, "lifelines_people.csv"))
    events <- read.csv(file.path(opts$path$data, "lifelines_events.csv"))

    opts <- clickme_vega(people, spec, params = list(event_data = events, height = 200), browse = FALSE)
    expect_true(file.exists(opts$path$html_file))
})

context("example translators")
test_that("example translators work", {
    set_root_path(system.file("examples", package="clickme"))

    for(ractive in plain_list_ractives()){
        test_translator(ractive)
    }
})
