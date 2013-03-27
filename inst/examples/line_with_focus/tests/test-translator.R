context("translate line_with_focus")

test_that("data frames are translated to the format expected by the template", {
    input_data <- data.frame(line = rep(c("l1", "l2"), each = 2), x = 1:4, y = 11:14)
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

    translated_input <- prepare_data(input_data)
    expect_equal(translated_input, expected_data)
})


