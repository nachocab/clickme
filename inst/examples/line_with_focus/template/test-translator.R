context("translate line_with_focus")

test_that("data frames are translated to the format expected by the template", {
    data <- data.frame(line = rep(c("l1", "l2"), each = 2), x = 1:4, y = 11:14)
    expected_data <- list(
                          list(key = "l1",
                               values = list(
                                             list(x = 1, y = 11),
                                             list(x = 2, y = 12)
                                        )
                          ),
                          list(key = "l2",
                               values = list(
                                             list(x = 3, y = 13),
                                             list(x = 4, y = 14)
                                        )
                          )
                     )

    # I'm testing get_data_as_nested_structure instead of get_data_as_json because it's easier to understand expected_data as a list, than as a JSON string.
    nested_data <- get_data_as_nested_structure(data)
    expect_equal(nested_data, expected_data)
})


