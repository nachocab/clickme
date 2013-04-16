context("map_data_names")

suppressMessages(set_root_path(system.file("examples", package="clickme")))

opts <- get_opts("force_directed", data_prefix = "data")
test_that("input data names can be mapped to those expected by the template", {
    opts$data <- data.frame(the_source = 1:4, the_target = 4:1, the_type = paste0("A", 1:4))
    opts$name_mappings <- c(the_target = "target", the_type = "type", the_source = "source")

    expect_message(mapped_data <- map_data_names(opts), "Renaming the_target")
    expect_true(all(names(mapped_data) %in% c("source", "target", "type")))
})

test_that("not all names are mapped", {
    opts$data <- data.frame(the_source = 1:4, target = 4:1, the_type = paste0("A", 1:4))
    opts$name_mappings <- c(the_type = "type", the_source = "source")
    expect_message(mapped_data <- map_data_names(opts), c("Renaming the_source"))

    expect_true(all(names(mapped_data) %in% c("source", "target", "type")))
})

opts$data <- data.frame(the_source = 1:4, target = 4:1, the_type = paste0("A", 1:4))

test_that("only data_names appear in the input data", {
    opts$name_mappings <- c(fake_type = "type", the_source = "source")
    expect_error(map_data_names(opts), "fake_type")
})

test_that("only data_names can be used to rename", {
    opts$name_mappings <- c(the_type = "fake_type", the_source = "source")
    expect_error(map_data_names(opts), "fake_type")
})

test_that("every element in name_mappings must be of the form: valid_name = \"non_valid_name\"", {
    opts$name_mappings <- c("type", "source")
    expect_error(map_data_names(opts), "source")
    opts$name_mappings <- c("type", the_source = "source")
    expect_error(map_data_names(opts)$data, "type")
})

context("validate_data_names")

test_that("all the required data_names are present", {
    opts$data <- data.frame(the_source = 1:4, the_target = 4:1, the_type = paste0("A", 1:4))
    expect_error(validate_data_names(opts), "data is missing the following required data_names")

    opts$data <- data.frame(source = 1:4, target = 4:1)
    expect_error(validate_data_names(opts), "data is missing the following required data_names")
})
