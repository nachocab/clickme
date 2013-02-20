context("prepare_for_template")

# return a filled matrix
mat <- function(elements=NULL, num_elements=nrow*ncol, nrow=5, ncol=2, scale_by=100, rownames=NULL, colnames=NULL){
    if (is.null(elements)){
        elements <- runif(num_elements) * scale_by
    }
    if (!is.null(ncol)){
        mat <- matrix(elements, ncol=ncol, byrow=T)
    } else {
        mat <- matrix(elements, nrow=nrow, byrow=T)
    }

    if (!is.null(rownames)) rownames(mat) <- rownames
    if (!is.null(colnames)) colnames(mat) <- colnames

    mat
}

test_that("scatterplot", {

    expect_true(all(c("x","y","name") %in% colnames(prepare_for_template(mat(ncol=3)))))
    expect_true(all(c("x","y","name") %in% colnames(prepare_for_template(mat(colnames=c("x","y","name"), ncol=3)))))
    expect_true(all(c("y","x","name") %in% colnames(prepare_for_template(mat(colnames=c("y","x","name"), ncol=3)))))

    expect_true(all(c("x","y","name") %in% colnames(prepare_for_template(data.frame(logFC=c(1,2,3), gene_name=c("a","b","c"), p_value=c(.01,.1,.009))))))
    expect_true(all(c("x","y","name") %in% colnames(prepare_for_template(data.frame(x=c(1,2,3), gene_name=c("a","b","c"), p_value=c(.01,.1,.009))))))
    expect_true(all(c("x","y","name") %in% colnames(prepare_for_template(data.frame(logFC=c(1,2,3), gene_name=c("a","b","c"), y=c(.01,.1,.009))))))

    expect_true(all(c("x","y","name") %in% colnames(prepare_for_template(data.frame(logFC=c(1,2,3), y=c(.01,.1,.009))))))
    expect_true(all(c("x","y","name") %in% colnames(prepare_for_template(data.frame(logFC=c(1,2,3), y=c(.01,.1,.009), other=c(1,2,3), other2=c("a","b","c"))))))

    expect_error(all(c("x","y","name") %in% colnames(prepare_for_template(data.frame(logFC=c(1,2,3))))))
})