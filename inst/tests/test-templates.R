context("templates")


test_that("the HTML example file for the force_directed template is generated", {
    template <- "force_directed"

    # we do this to ensure that the HTML file doesn't exist before we create it
    opts <- get_opts(template)
    unlink(opts$path$html_file)
    data <- read.csv(file.path(opts$path$data, "original_data.csv"))

    clickme(data, template, open = FALSE)

    expect_true(file.exists(opts$path$html_file))
})

test_that("the HTML example file for the par_coords template is generated", {
    template <- "par_coords"

    # we do this to ensure that the HTML file doesn't exist before we create it
    opts <- get_opts(template)
    unlink(opts$path$html_file)
    data <- read.csv(file.path(opts$path$data, "original_data.csv"))

    clickme(data, template, params = list(color_by = "economy"), open = FALSE)

    expect_true(file.exists(opts$path$html_file))
})

context("example translators")

test_that("example translators work", {
    for(template in plain_list_templates()){
        test_template(template)
    }
})
