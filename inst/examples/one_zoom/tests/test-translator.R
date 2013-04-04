context("translate one_zoom")

test_that("a phylo tree is translated to the format expected by the template", {
    library(ape)

    opts <- get_opts("one_zoom")
    opts$data <- read.tree(text = "(((A:4.2,B:4.2):3.1,C:7.3):6.3,D:13.6);")
    expected_data <- "(((A:4.2,B:4.2):3.1,C:7.3):6.3,D:13.6);"

    tree_data <- get_data_as_tree(opts)
    expect_equal(tree_data, expected_data)
})

test_that("a file containing a phylo tree is translated to the format expected by the template", {
    opts <- get_opts("one_zoom")
    opts$data <- file.path(system.file("examples", package = "clickme"), "tmp.tree")
    write("(((A:4.2,B:4.2):3.1,C:7.3):6.3,D:13.6);", file = opts$data)
    expected_data <- "(((A:4.2,B:4.2):3.1,C:7.3):6.3,D:13.6);"

    tree_data <- get_data_as_tree(opts)
    expect_equal(tree_data, expected_data)

    unlink(opts$data)
})

test_that("a string containing a tree in Newick format is translated to the format expected by the template", {
    opts <- get_opts("one_zoom")
    opts$data <- "(((A:4.2,B:4.2):3.1,C:7.3):6.3,D:13.6);"
    expected_data <- "(((A:4.2,B:4.2):3.1,C:7.3):6.3,D:13.6);"

    tree_data <- get_data_as_tree(opts)
    expect_equal(tree_data, expected_data)
})