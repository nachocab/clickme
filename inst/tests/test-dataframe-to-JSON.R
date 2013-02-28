context("dataframe_to_JSON")

test_that("dataframe_to_JSON", {
    expect_equal("[{}]", dataframe_to_JSON(data.frame()))
    expect_equal("[{\"x\":1}]", dataframe_to_JSON(data.frame(x=1)))
    expect_equal("[{\"x\":1,\"y\":4},\n{\"x\":2,\"y\":5}]", dataframe_to_JSON(data.frame(x=c(1,2), y=c(4,5))))
    expect_equal("[{\"x\":true,\"y\":4},\n{\"x\":false,\"y\":5}]", dataframe_to_JSON(data.frame(x=c(TRUE,FALSE), y=c(4,5))))
    expect_equal("[{\"x\":\"a\",\"y\":4},\n{\"x\":\"b\",\"y\":5}]", dataframe_to_JSON(data.frame(x=factor(c("a","b")), y=c(4,5))))
    expect_equal("[{\"x\":1,\"y\":\"don't\"},\n{\"x\":2,\"y\":\"a\"}]", dataframe_to_JSON(data.frame(x=c(1,2), y=c("don't","a"))))
    expect_equal("[{\"x\":1,\"y\":\"null\",\"z\":\"null\"},\n{\"x\":\"null\",\"y\":2,\"z\":3}]", dataframe_to_JSON(data.frame(x=c(1,-Inf), y=c(Inf,2), z=c(NA,3))))
})