context("translate force_directed")

test_that("dataframes are translated to the format expected by the template", {
    input <- data.frame(a=1:4, b=4:1, type=letters[1:4])
    translated_input <- translate(input)
    expect_equal(translated_input, "[{\"a\":1,\"b\":4,\"type\":\"a\"},\n{\"a\":2,\"b\":3,\"type\":\"b\"},\n{\"a\":3,\"b\":2,\"type\":\"c\"},\n{\"a\":4,\"b\":1,\"type\":\"d\"}]")
})


