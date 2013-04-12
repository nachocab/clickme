context("translate longitudinal_heatmap")

test_that("gene_symbol and cluster names are coerced if not present in the input data object", {
    data <- as.data.frame(mat(ncol = 5, nrow = 10))
    colnames(data) <- c(paste("hiv", "day", c(0, 4), sep="_"), paste("flu", "day", c(0, 2, 3), sep="_"))
    rownames(data) <- LETTERS[1:10]

    coerced_data <- coerce_names(data)
    expect_true(all(c("gene_symbol", "cluster") %in% colnames(coerced_data)))
})

test_that("the input data object is stored as a csv file", {
    test_data_prefix <- "test_data"
    opts <- get_opts("longitudinal_heatmap", data_prefix = test_data_prefix)

    opts$data <- mat(ncol = 5, nrow = 10)
    colnames(opts$data) <- c(paste("hiv", "day", c(0, 4), sep="_"), paste("flu", "day", c(0, 2, 3), sep="_"))
    rownames(opts$data) <- LETTERS[1:10]


    csv_file <- get_data_as_csv_file(opts)
    expect_correct_file(opts, "csv")

})
