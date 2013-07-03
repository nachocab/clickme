library(testthat)

old_clickme_template_path <- getOption("clickme_template_path")
old_clickme_output_path <- getOption("clickme_output_path")

set_default_paths()
test_check("clickme")

options(clickme_template_path = old_clickme_template_path, clickme_output_path = old_clickme_output_path)