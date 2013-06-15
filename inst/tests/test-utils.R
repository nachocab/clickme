context("utils")


test_that("appends styles and scripts", {

    opts <- get_default_opts("test_template")
    opts <- add_output_file_name(opts)
    opts <- add_output_paths(opts)

    path <- get_asset_path(opts, "http://some_file.js")
    expect_equal(path, "http://some_file.js")

    path <- get_asset_path(opts, "abc.css")
    expect_equal(path, "clickme_assets/test_template/abc.css")

    path <- get_asset_path(opts, "$shared/def.js")
    expect_equal(path, "clickme_assets/def.js")

    opts$config$styles <- c("abc.css", "$shared/def.css", "http://some_file.css")
    opts$config$scripts <- c("abc.js", "$shared/def.js", "http://some_file.js")

    expected_styles <- paste("<link href=\"clickme_assets/test_template/abc.css\" rel=\"stylesheet\">",
                             "<link href=\"clickme_assets/def.css\" rel=\"stylesheet\">",
                             "<link href=\"http://some_file.css\" rel=\"stylesheet\">",
                             sep = "\n")
    expected_scripts <- paste("<script src=\"clickme_assets/test_template/abc.js\"></script>",
                              "<script src=\"clickme_assets/def.js\"></script>",
                              "<script src=\"http://some_file.js\"></script>",
                              sep = "\n")

    expected_styles_and_scripts <- paste0(c(expected_styles, expected_scripts), collapse = "\n")
    assets <- get_assets(opts)
    expect_equal(assets, expected_styles_and_scripts)
})

# test_that("create_data_file", {
#     template <- "par_coords"
#     opts <- get_opts(template, data_prefix = "test_data")
#     opts$data <- "[{\"a\":3,\"b\":5}]"

#     json_file <- create_data_file(opts, "json", quote_escaped = FALSE)
#     expect_equal(json_file, file.path(opts$relative_path$data, "test_data.json"))
#     expect_correct_file(opts, "json", opts$data)

#     opts$data <- data.frame(a = c(1, 2), b = c(3, 4))
#     csv_file <- create_data_file(opts, "csv", quote_escaped = FALSE)
#     expect_correct_file(opts, "csv", "\"a\",\"b\"\n1,3\n2,4")
# })


test_that("get_padding_param", {
    # default global padding
    opts <- list(params = list(padding = c(24, 0, 12, 200)))
    padding <- get_padding_param(opts)
    expect_equal(padding, "{\"top\":24,\"right\":0,\"bottom\":12,\"left\":200}")

    # spec-specific padding
    opts <- list(params = list(padding = NULL))
    padding <- get_padding_param(opts, c(10, 10, 10, 10))
    expect_equal(padding, "{\"top\":10,\"right\":10,\"bottom\":10,\"left\":10}")

    # user-provided param padding
    opts <- list(params = list(padding = c(10,20,30,40)))
    padding <- get_padding_param(opts)
    expect_equal(padding, "{\"top\":10,\"right\":20,\"bottom\":30,\"left\":40}")

    # changed order
    opts <- list(params = list(padding = c(right = 10, bottom = 20, left = 30, top = 40)))
    padding <- get_padding_param(opts)
    expect_equal(padding, "{\"right\":10,\"bottom\":20,\"left\":30,\"top\":40}")

    # wrong input
    opts <- list(params = list(padding = c(10,20,30)))
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

test_that("export_assets updates output shared and output template assets", {
    opts <- new_template("test_template")
    opts$config$styles <- c("abc.css", "$shared/def.css", "http://somefile.css")
    opts <- add_output_file_name(opts)
    opts <- add_output_paths(opts)

    template_asset_path <- file.path(opts$paths$template_assets, "abc.css")
    file.create(template_asset_path)
    shared_asset_path <- file.path(opts$paths$shared_assets, "def.css")
    file.create(shared_asset_path)

    export_assets(opts)
    expect_true(file.exists(template_asset_path))
    expect_true(file.exists(shared_asset_path))

    unlink(opts$paths$template, recursive = TRUE)
    unlink(opts$paths$output_template_assets, recursive = TRUE)
    unlink(file.path(opts$paths$shared_assets, "def.css"))
    unlink(file.path(opts$paths$output_shared_assets, "def.css"))
})

test_that("reorder_data_by_color", {
    data <- data.frame(x=c(1,2,3))
    params <- list(colorize = c("a","b","c"))
    reordered_data <- reorder_data_by_color(data, params)
    expect_equal(reordered_data$x, c(3, 2, 1))

    params <- list(colorize = c("a","b","c"), palette = c(a = "blue", c = "red", b = "green"))
    reordered_data <- reorder_data_by_color(data, params)
    expect_equal(reordered_data$x, c(2, 3, 1))
})
