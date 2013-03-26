context("translate one_zoom")

test_that("a phylo tree is translated to the format expected by the template", {
    library(ape)
    input_data <- read.tree(text="(((A:4.2,B:4.2):3.1,C:7.3):6.3,D:13.6);")
    expected_data <- "(((A:4.2,B:4.2):3.1,C:7.3):6.3,D:13.6);"

    opts <- get_opts("one_zoom")
    opts <- translate(input_data, opts)

    expect_equal(opts$data, expected_data)
})

test_that("a file containing a phylo tree is translated to the format expected by the template", {
    input_data <- file.path(system.file("examples", package = "clickme"), "tmp.tree")
    write("(((A:4.2,B:4.2):3.1,C:7.3):6.3,D:13.6);", file = input_data)
    expected_data <- "(((A:4.2,B:4.2):3.1,C:7.3):6.3,D:13.6);"

    opts <- get_opts("one_zoom")
    opts <- translate(input_data, opts)

    expect_equal(opts$data, expected_data)

    unlink(input_data)
})

test_that("a string containing a tree in Newick format is translated to the format expected by the template", {
    input_data <- "(((A:4.2,B:4.2):3.1,C:7.3):6.3,D:13.6);"
    expected_data <- "(((A:4.2,B:4.2):3.1,C:7.3):6.3,D:13.6);"

    opts <- get_opts("one_zoom")
    opts <- translate(input_data, opts)

    expect_equal(opts$data, expected_data)
})