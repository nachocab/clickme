context("clickme")

test_that("clickme", {
    data <- data.frame(logFC=c(1,2,3), y=c(.01,.1,.009))
    clickme(data, "scatterplot")

    expect_true(file.exists("data.json"))
    expect_equal(to_JSON(prepare_for_template(data)), paste(readLines("data.json"), collapse="\n"))
        # fills the template with the file path
        # creates a server
        # generates a URL for this template
})