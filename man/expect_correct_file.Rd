\name{expect_correct_file}
\alias{expect_correct_file}
\title{Test generated file}
\usage{
  expect_correct_file(opts, extension,
    expected_data = NULL, test_data_name = "test_data")
}
\arguments{
  \item{opts}{options}

  \item{extension}{extension of the file}

  \item{expected_data}{data that should be stored in the
  test file.}

  \item{test_data_name}{value used on the
  \code{get_opts(..., data_name = test_data_name)} call. It
  is "test_data" by default.}
}
\description{
  Test that the path exists, and that the contents are as
  expected
}

