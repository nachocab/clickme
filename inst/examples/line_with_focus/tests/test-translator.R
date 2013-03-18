context("translate test_translator")

test_that("dataframes are translated to the format expected by the template", {
    input <- data.frame(line=rep(c("l1", "l2"), each=2), x=1:4, y=11:14)
    translated_input <- prepare_data(input)
    expect_equal(translated_input, list(list(key="l1", values=list(list(x=1, y=11), list(x=2, y=12))), list(key="l2", values=list(list(x=3, y=13), list(x=4, y=14)))))
})


