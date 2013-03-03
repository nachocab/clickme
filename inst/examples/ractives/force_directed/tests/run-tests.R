library("testthat")

# setwd("path/to/tests")
source(file.path("..", "template", "translator.R"))
test_file("test-translator.R")