\name{match_to_groups}
\alias{match_to_groups}
\title{Match elements to groups}
\usage{
  match_to_groups(subset, groups, replace_nas = "Other",
    strict_dups = FALSE)
}
\arguments{
  \item{subset}{vector of elements}

  \item{groups}{list of groups}

  \item{replace_nas}{how to handle elements that don't
  appear in any of the groups. If a string is provided, it
  uses it as a new group for these elements.}

  \item{strict_dups}{how to handle elements that appear in
  multiple groups. By default, the first matching group is
  reported and a warning is issued. If TRUE, it raises an
  error.

  It returns the name of the group where each element in
  the subset appears. If not in any group, it combines them
  into the "other " group (intentional space, in case
  "other" exists)}
}
\description{
  Match elements to groups
}

