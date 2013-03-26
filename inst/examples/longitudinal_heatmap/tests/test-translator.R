context("translate longitudinal_heatmap")

test_that("gene_symbol and cluster names are coerced if not present in the input data object", {
    input_data <- mat(ncol=5, nrow=10)
    colnames(input_data) <- c(paste("hiv", "day", c(0,4), sep="_"), paste("flu", "day", c(0,2,3), sep="_"))
    rownames(input_data) <- LETTERS[1:10]

    prepared_data <- prepare_data(input_data)
    expect_true(all(c("gene_symbol", "cluster") %in% colnames(prepared_data)))
})

test_that("the input data object is stored as a csv file", {
    input_data <- mat(ncol=5, nrow=10)
    colnames(input_data) <- c(paste("hiv", "day", c(0,4), sep="_"), paste("flu", "day", c(0,2,3), sep="_"))
    rownames(input_data) <- LETTERS[1:10]

    test_data_name <- "test_data"
    opts <- get_opts("longitudinal_heatmap", data_name = test_data_name)

    opts <- translate(input_data, opts)
    expected_data <- paste0("\"", file.path(opts$relative_path$data, paste0(test_data_name, ".csv")), "\"")

    expect_equal(opts$data, expected_data)
    expect_true(file.exists(file.path(opts$path$data, paste0(test_data_name, ".csv"))))

    unlink(file.path(opts$path$data, paste0(test_data_name, ".csv")))
})
