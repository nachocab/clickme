# context("templates")


# test_that("the HTML example file for the force_directed template is generated", {
#     template <- "force_directed"

#     # we do this to ensure that the HTML file doesn't exist before we create it
#     opts <- get_opts(template)
#     unlink(file_structure$paths$output_file)
#     data <- read.csv(file.path(file_structure$paths$data, "original_data.csv"))

#     clickme(data, template, open = FALSE)

#     expect_true(file.exists(file_structure$paths$output_file))
# })

# test_that("the HTML example file for the par_coords template is generated", {
#     template <- "par_coords"

#     # we do this to ensure that the HTML file doesn't exist before we create it
#     opts <- get_opts(template)
#     unlink(file_structure$paths$output_file)
#     data <- read.csv(file.path(file_structure$paths$data, "original_data.csv"))

#     clickme(data, template, params = list(color_by = "economy"), open = FALSE)

#     expect_true(file.exists(file_structure$paths$output_file))
# })

# context("example translators")

# test_that("example translators work", {
#     for(template in plain_list_templates()){
#         test_chart(template)
#     }
# })
