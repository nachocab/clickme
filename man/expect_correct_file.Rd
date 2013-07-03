\name{expect_correct_file}
\alias{expect_correct_file}
\title{Run a template demo}
\usage{
  expect_correct_file(opts, extension,
    expected_data = NULL, test_data_prefix = "test_data")
}
\arguments{
  \item{template}{name of template Test generated file

  Test that the path exists, and that the contents are as
  expected}

  \item{opts}{options}

  \item{extension}{extension of the file}

  \item{expected_data}{data that should be stored in the
  test file.}

  \item{test_data_prefix}{value used on the
  \code{get_opts(..., data_prefix = test_data_prefix)}
  call. It is "test_data" by default.}
}
\description{
  Run a template demo
}

