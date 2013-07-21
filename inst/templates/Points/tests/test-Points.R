context("Points")

test_that("points have names", {
    params <- list(x = 1:10)
    points <- Points$new(params)
    points$get_data()
    expect_equal(points$data, data.frame(x = 1:10, y = 1:10, point_name = as.character(1:10)))

    params <- list(x = 1:10, names = letters[1:10])
    points <- Points$new(params)
    points$get_data()
    expect_equal(points$data, data.frame(x = 1:10, y = 1:10, point_name = letters[1:10]))
})

test_that("validate_formats", {
    params <- list(x = 1:10, extra = list(a = 1:10), formats = list(paco = "d"))
    points <- Points$new(params)
    points$get_params()
    expect_error(points$get_data(), "\n\n\tThe following format names are not x, y, or any of the extra names:\n\tpaco\n\n")
})

test_that("color_domain", {
    params <- list(color_groups = c(.5,.4,.3,.2,.1))
    points <- Points$new(params)
    points$get_params()
    expect_equal(points$params$color_domain, c(.1, .5), info = "quantitative color_groups, no color_domain")

    params <- list(color_groups = c(.5,.4,.3,.2,.1), color_domain = c(0,1))
    points <- Points$new(params)
    points$get_params()
    expect_equal(points$params$color_domain, c(0, 1), info = "quantitative color_groups, color_domain")

    params <- list(color_groups = letters[1:10], color_domain = c(0,1))
    points <- Points$new(params)
    expect_error(points$get_params(), "color_groups has categorical values", info = "categorical color_groups, color_domain")
})

context("Points clickme")

# sanity test
test_that("clickme", {
    capture.output(expect_that(clickme("points", 1:10), not(throws_error())))
})