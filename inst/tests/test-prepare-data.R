context("check_names")

test_that("data column names match template_config column names", {

    clickme_path(system.file("demo", package="clickme"))
    template_id <- "nachocab_scatterplot"
    config_path <- file.path(.clickme_env$path, .clickme_env$templates_dir_name, template_id, .clickme_env$config_file_name)
    template_config <- yaml.load_file(config_path)

    # canonical columns
    data <- data.frame(y=c(.01,.1,.009), name=c("a","b","c"), x=c(1,2,3))
    data_prepared <- check_names(data, template_config)
    expect_true(all(c("x","y","name") %in% colnames(data_prepared)))
    expect_equal(c(1,2,3), data_prepared$x)
    expect_equal(c(.01,.1,.009), data_prepared$y)

    # non-canonical columns
    data <- data.frame(logFC=c(1,2,3), p_value=c(.01,.1,.009), gene_name=c("a","b","c"))
    data_prepared <- check_names(data, template_config)
    expect_true(all(c("x","y","name") %in% colnames(data_prepared)))
    expect_equal(c(1,2,3), data_prepared$x)
    expect_equal(c(.01,.1,.009), data_prepared$y)

    data <- data.frame(logFC=c(1,2,3), y=c(.01,.1,.009), gene_name=c("a","b","c"))
    data_prepared <- check_names(data, template_config)
    expect_true(all(c("x","y","name") %in% colnames(data_prepared)))
    expect_equal(c(1,2,3), data_prepared$x)
    expect_equal(c(.01,.1,.009), data_prepared$y)

    # missing name column
    data <- data.frame(logFC=c(1,2,3), y=c(.01,.1,.009))
    data_prepared <- check_names(data, template_config)
    expect_true(all(c("x","y","name") %in% colnames(data_prepared)))
    expect_equal(c("1","2","3"), data_prepared$name)
    expect_equal(c(1,2,3), data_prepared$x)
    expect_equal(c(.01,.1,.009), data_prepared$y)

    # extra columns
    data <- data.frame(logFC=c(1,2,3), y=c(.01,.1,.009), z=c(1,2,3), color=c("a","b","c"))
    data_prepared <- check_names(data, template_config)
    expect_true(all(c("x", "y", "name", "z", "color") %in% colnames(data_prepared)))
    expect_equal(c(1,2,3), data_prepared$x)
    expect_equal(c(.01,.1,.009), data_prepared$y)

    # missing canonical columns
    data <- data.frame(logFC=c(1,2,3))
    expect_error(check_names(data, template_config))
})