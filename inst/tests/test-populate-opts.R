context("populate_opts")

library(yaml)

test_that("default opts are respected", {

    data <- mat()
    default_opts <- populate_opts(data, "scatterplot", NULL)
    expect_true(grepl(file.path("clickme", "inst", "templates"), default_opts$templates_folder))
    expect_true(grepl(file.path("clickme", "inst", "templates", "scatterplot.Rmd"), default_opts$template_path))
    expect_true(grepl(file.path("clickme", "inst", "templates", "scatterplot.yml"), default_opts$config_path))
    expect_equal(c("x", "y"), default_opts$template_config$numeric)
    expect_equal("name", default_opts$template_config$character)
    expect_true(grepl(file.path("clickme", "inst", "skeleton.Rmd"), default_opts$skeleton_path))
    expect_true(grepl(file.path("data.json"), default_opts$data_path))
    expect_true(grepl(file.path("data.html"), default_opts$visualization_path))

})

test_that("opts can be customized", {

    data <- mat()

    tmp_files <- c("/tmp/skeleton.Rmd", "/tmp/my_plot.Rmd", "/tmp/my_plot.yml")
    sapply(tmp_files, file.create)
    custom_opts <- populate_opts(data, "my_plot", list(templates_folder = "/tmp",
                                                            skeleton_path = "/tmp/skeleton.Rmd",
                                                            data_path = "/tmp/data.json",
                                                            visualization_path = "/tmp/data.html"))

    expect_equal(file.path("/tmp"), custom_opts$templates_folder)
    expect_equal(file.path("/tmp", "my_plot.Rmd"), custom_opts$template_path)
    expect_equal(file.path("/tmp", "my_plot.yml"), custom_opts$config_path)
    expect_equal(NULL, custom_opts$template_config)
    expect_equal(file.path("/tmp", "skeleton.Rmd"), custom_opts$skeleton_path)
    expect_equal(file.path("/tmp", "data.json"), custom_opts$data_path)
    expect_equal(file.path("/tmp", "data.html"), custom_opts$visualization_path)
    sapply(tmp_files, file.remove)

})

test_that("opts are valid", {
    data <- mat()
    expect_error(populate_opts(data, "fake_template", NULL))
})
