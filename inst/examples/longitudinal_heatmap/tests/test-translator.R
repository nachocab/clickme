context("translate longitudinal_heatmap")

test_that("dataframes are translated to the format expected by the template", {
    data <- mat(ncol=5, nrow=10)
    colnames(data) <- c(paste("hiv", "day", c(0,4), sep="_"), paste("flu", "day", c(0,2,3), sep="_"))
    rownames(data) <- LETTERS[1:10]

    test_data_file_name <- "test_data.csv"
    opts <- get_opts("longitudinal_heatmap", data_file_name = test_data_file_name)

    translated_data <- clickme_translate(data, opts)
    expected_translated_data <- paste0("\"", file.path(opts$relative_path$data, test_data_file_name), "\"")

    expect_equal(translated_data, expected_translated_data)
    expect_true(file.exists(file.path(opts$path$data, test_data_file_name)))
    cleanup_files(file.path(opts$path$data, test_data_file_name))
})
