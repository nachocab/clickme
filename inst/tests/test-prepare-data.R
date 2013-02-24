context("prepare_data")

test_that("data is prepared according to the template", {

    template_id <- "nachocab_scatterplot"
    expect_true(all(c("x","y","name") %in% colnames(prepare_data(mat(ncol=3), template_id))))
    expect_true(all(c("x","y","name") %in% colnames(prepare_data(mat(colnames=c("x","y","name"), ncol=3), template_id))))
    expect_true(all(c("y","x","name") %in% colnames(prepare_data(mat(colnames=c("y","x","name"), ncol=3), template_id))))

    expect_true(all(c("x","y","name") %in% colnames(prepare_data(data.frame(logFC=c(1,2,3), gene_name=c("a","b","c"), p_value=c(.01,.1,.009)), template_id))))
    expect_true(all(c("x","y","name") %in% colnames(prepare_data(data.frame(x=c(1,2,3), gene_name=c("a","b","c"), p_value=c(.01,.1,.009)), template_id))))
    expect_true(all(c("x","y","name") %in% colnames(prepare_data(data.frame(logFC=c(1,2,3), gene_name=c("a","b","c"), y=c(.01,.1,.009)), template_id))))

    expect_true(all(c("x","y","name") %in% colnames(prepare_data(data.frame(logFC=c(1,2,3), y=c(.01,.1,.009)), template_id))))
    expect_true(all(c("x","y","name") %in% colnames(prepare_data(data.frame(logFC=c(1,2,3), y=c(.01,.1,.009), other=c(1,2,3), other2=c("a","b","c")), template_id))))

    expect_error(all(c("x","y","name") %in% colnames(prepare_data(data.frame(logFC=c(1,2,3)), template_id))))
})