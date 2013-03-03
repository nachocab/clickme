context("validate_data_names")

test_that("an error is raised if there are not enough valid names", {
    set_root_path(system.file("examples", package="clickme"))
    ractive <- "line_with_focus"
    opts <- get_opts(ractive, data_file_name = "data")

    data <- data.frame(x=1:3, y=4:6)
    expect_error(validate_data_names(data, opts), "The data object is missing the following names: line")

    data <- data.frame(x=1:3, invalid_y=4:6)
    expect_error(validate_data_names(data, opts), "The data object is missing the following names: line")

})

test_that("valid names are not modified, whatever their order", {
    set_root_path(system.file("examples", package="clickme"))
    ractive <- "line_with_focus"
    opts <- get_opts(ractive, data_file_name = "data")

    data <- data.frame(y=4:6, line=letters[1:3], x=1:3, stringsAsFactors=FALSE)
    checked_data <- validate_data_names(data, opts)

    expect_equal(data$line, letters[1:3])
    expect_equal(data$x, 1:3)
    expect_equal(data$y, 4:6)
})

test_that("invalid names are replaced with missing valid names in the order they were specified in template_config", {
    set_root_path(system.file("examples", package="clickme"))
    ractive <- "line_with_focus"
    opts <- get_opts(ractive, data_file_name = "data")

    data <- data.frame(y=4:6, invalid_name=letters[1:3], x=1:3, stringsAsFactors=FALSE)
    expect_message(checked_data <- validate_data_names(data, opts))

    # Rescuing the valid columns will often be enough to correct the invalid columns...
    expect_equal(data$invalid_name, checked_data$line)
    expect_equal(data$x, checked_data$x)
    expect_equal(data$y, checked_data$y)

    data <- data.frame(invalid_y=4:6, invalid_name=letters[1:3], x=1:3, stringsAsFactors=FALSE)
    expect_message(checked_data <- validate_data_names(data, opts))

    # ...but not always because we have no way of knowing if the invalid columns are ordered correctly.
    expect_equal(data$invalid_y, checked_data$line)
    expect_equal(data$x, checked_data$x)
    expect_equal(data$invalid_name, checked_data$y)
})