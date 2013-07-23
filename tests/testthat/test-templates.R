# context("templates")


# test_that("the HTML example file for the force_directed template is generated", {
#     template <- "force_directed"

#     # we do this to ensure that the HTML file doesn't exist before we create it
#     opts <- get_opts(template)
#     unlink(internal$file$paths$output_file)
#     data <- read.csv(file.path(internal$file$paths$data, "original_data.csv"))

#     clickme(data, template, open = FALSE)

#     expect_true(file.exists(internal$file$paths$output_file))
# })

# test_that("the HTML example file for the par_coords template is generated", {
#     template <- "par_coords"

#     # we do this to ensure that the HTML file doesn't exist before we create it
#     opts <- get_opts(template)
#     unlink(internal$file$paths$output_file)
#     data <- read.csv(file.path(internal$file$paths$data, "original_data.csv"))

#     clickme(data, template, params = list(color_by = "economy"), open = FALSE)

#     expect_true(file.exists(internal$file$paths$output_file))
# })

context("Installed templates")

for(template in plain_list_templates()){
    test_template(template)
}
