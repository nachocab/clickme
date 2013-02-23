# @keyword internal
"%notin%" <- function(x,y) !(x %in% y)

# @keyword internal
# @name nulldefault-infix
"%||%" <- function(a, b) {
  if (!is.null(a)) a else b
}