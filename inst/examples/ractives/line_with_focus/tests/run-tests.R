library("testthat")

# setwd("path/to/tests")
setwd("/Users/nacho/Documents/Code/Rprojects/clickme_ractives/ractives/line_with_focus/tests/")

source(file.path("..", "template", "translator.R"))
test_file("test-translator.R")