context("utils")

suppressMessages(set_root_path(system.file("ractives", package="clickme")))

test_that("appends styles and scripts", {
    ractive <- "par_coords"
    opts <- get_opts(ractive, data_prefix = "data")

    expected_scripts <- "<script src=\"par_coords/external/d3.v3.js\"></script>\n<script src=\"par_coords/external/d3.parcoords.js\"></script>"
    expect_equal(get_scripts(opts), expected_scripts)

    expected_styles <- "<link href=\"par_coords/external/d3.parcoords.css\" rel=\"stylesheet\">\n<link href=\"par_coords/external/style.css\" rel=\"stylesheet\">"
    expect_equal(get_styles(opts), expected_styles)

    expected_styles_and_scripts <- paste0(c(expected_styles, expected_scripts), collapse = "\n")
    expect_equal(get_external(opts), expected_styles_and_scripts)
})

test_that("create_data_file", {
    ractive <- "par_coords"
    opts <- get_opts(ractive, data_prefix = "test_data")
    opts$data <- "[{\"a\":3,\"b\":5}]"

    json_file <- create_data_file(opts, "json", quote_escaped = FALSE)
    expect_equal(json_file, file.path(opts$relative_path$data, "test_data.json"))
    expect_correct_file(opts, "json", opts$data)

    opts$data <- data.frame(a = c(1, 2), b = c(3, 4))
    csv_file <- create_data_file(opts, "csv", quote_escaped = FALSE)
    expect_correct_file(opts, "csv", "\"a\",\"b\"\n1,3\n2,4")
})


test_that("get_padding_param", {
    # default global padding
    opts <- get_opts("par_coords")
    padding <- get_padding_param(opts)
    expect_equal(padding, "{\"top\":24,\"right\":0,\"bottom\":12,\"left\":200}")

    # spec-specific padding
    opts <- get_opts("par_coords")
    opts$params$padding <- NULL
    padding <- get_padding_param(opts, c(10, 10, 10, 10))
    expect_equal(padding, "{\"top\":10,\"right\":10,\"bottom\":10,\"left\":10}")

    # user-provided param padding
    opts <- get_opts("par_coords", params = list(padding = c(10, 20, 30, 40)))
    padding <- get_padding_param(opts)
    expect_equal(padding, "{\"top\":10,\"right\":20,\"bottom\":30,\"left\":40}")

    # changed order
    opts <- get_opts("par_coords", params = list(padding = c(right = 10, bottom = 20, left = 30, top = 40)))
    padding <- get_padding_param(opts)
    expect_equal(padding, "{\"right\":10,\"bottom\":20,\"left\":30,\"top\":40}")

    # wrong input
    opts <- get_opts("par_coords", params = list(padding = c(10, 20, 30)))
    expect_error(get_padding_param(opts), "Please provide four padding values")
})

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
    expect_warning(match_to_groups(subset, groups, strict_dups = FALSE), "duplicated elements in your groups:\na\nb")
    expect_error(match_to_groups(subset, groups, strict_dups = TRUE), "duplicated elements in your groups:\na\nb")
})


test_that("disjoint_sets", {
    a <- c(1:3,5)
    b <- c(0,2:4)
    expect_equal(disjoint_sets(a,b), list(a = c(1,5), b = c(0,4), both = c(2,3)))

    expect_equal(disjoint_sets(a,b, names = c("A", "B", "Both")), list(A = c(1,5), B = c(0,4), Both = c(2,3)))
})
