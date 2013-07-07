context("utils")

test_that("scale_type", {
    expect_equal(scale_type(NULL), "categorical")
    expect_equal(scale_type(c(1)), "categorical")
    expect_equal(scale_type(c("a")), "categorical")
    expect_equal(scale_type(c("a", "b", "c")), "categorical")
    expect_equal(scale_type(c(1, 2, 3)), "quantitative")
})

test_that("match_to_groups", {
    subset  <- c("w","b","p","e","j")
    groups <- list(a=letters[1:10], b = letters[11:20], c = letters[21:26])
    expect_equal(match_to_groups(subset, groups), c("c","a","b","a","a"))

    subset  <- c("w","b","A","B","j")
    expect_equal(match_to_groups(subset, groups, replace_nas = "Other"), c("c","a","Other","Other","a"))

    subset <- c("a","b","c")
    groups <- list(a = c("a","b"), b = c("a","b","c"))
    suppressWarnings(expect_equal(match_to_groups(subset, groups, strict_dups = FALSE), c("a","a","b")))
    expect_message(match_to_groups(subset, groups, strict_dups = FALSE), "The following elements appear in more than one group:\na\nb")
    expect_error(match_to_groups(subset, groups, strict_dups = TRUE), "The following elements appear in more than one group:\na\nb")
})


test_that("disjoint_sets", {
    a <- c(1:3,5)
    b <- c(0,2:4)
    expect_equal(disjoint_sets(a,b), list(a = c(1,5), b = c(0,4), both = c(2,3)))

    expect_equal(disjoint_sets(a,b, names = c("A", "B", "Both")), list(A = c(1,5), B = c(0,4), Both = c(2,3)))
})

test_that("extract_functions", {
    expressions <- c(" params$a ", "a")
    expect_true(length(extract_functions(expressions)) == 0)

    expressions <- c(" rjson::toJSON(paco) ", "clickme:::my_fun()")
    expect_true(length(extract_functions(expressions)) == 0)

    expressions <- c("a()", " myFun(b, b3) ", " my_fun2()  ", "my.fun3(a = 3)", ".my.fun4()")
    expect_equal(extract_functions(expressions), c("a", "myFun", "my_fun2", "my.fun3", ".my.fun4"))

})


test_that("title_case", {
    strings <- c("paco", "pepe")
    expect_equal(title_case(strings), c("Paco","Pepe"))
})

test_that("camel_case", {
    strings <- c("paco_pepe", "paco.pepe", "paco.pepe_luis")
    expect_equal(camel_case(strings), c("PacoPepe","PacoPepe", "PacoPepeLuis"))
})

test_that("snake_case", {
    strings <- c("PacoPepe", "pacoPepe", "Paco")
    expect_equal(snake_case(strings), c("paco_pepe","paco_pepe", "paco"))
})

test_that("clickme", {
    expect_match(make_iframe("test.html", 980, 980), "<iframe width = \"980\" height = \"980\" src=\"test\\.html\"> </iframe>")
})