context("clickme_translate")

test_that("dataframes are translated to the format expected by the ractive", {
    data <- clickme:::mat(ncol=5, nrow=10)
    colnames(data) <- c(paste("hiv", "day", c(0,4), sep="_"), paste("flu", "day", c(0,2,3), sep="_"))
    rownames(data) <- LETTERS[1:10]
    set_root_path(system.file("examples", package="clickme"))
    opts <- clickme:::add_ractive_opts("longitudinal_heatmap")

    translated_data <- clickme_translate(data, opts)

    expected_translated_data <- clickme:::clickme_quote(file.path(opts$relative_path$data, "test_data.csv"))

    expect_equal(translated_data, expected_translated_data)
    expect_true(file.exists(file.path(opts$path$template, expected_translated_data)))
})
