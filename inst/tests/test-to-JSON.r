context("to_JSON")

test_that("to_JSON", {
    expect_equal("[{\"x\":1,\"y\":4},\n{\"x\":2,\"y\":5}]", to_JSON(data.frame(x=c(1,2), y=c(4,5))))
    expect_equal("[{\"x\":1,\"y\":\"don't\"},\n{\"x\":2,\"y\":\"a\"}]", to_JSON(data.frame(x=c(1,2), y=c("don't","a"))))
    expect_equal("[{\"x\":1,\"y\":\"null\",\"z\":\"null\"},\n{\"x\":\"null\",\"y\":2,\"z\":3}]", to_JSON(data.frame(x=c(1,-Inf), y=c(Inf,2), z=c(NA,3))))
})