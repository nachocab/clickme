get_padding_param <- function(opts) {
    library(rjson)
    padding <- opts$params$padding

    if (length(padding) != 4){
      cat("length(padding): ", length(padding), "\n")
        stop("Please provide four padding values and a scale. (currently ", paste(padding, collapse=", "), ")")
    }

    if (is.null(names(padding))) {
        names(padding) <- c("top", "left", "bottom", "right")
    }

    padding <- toJSON(padding)

    padding
}

# opts$data = data matrix [n x p]
# opts$group = vector of groups [length n]
# opts$reorder = 1/0 according to whether to reorder variables by clustering
get_data_as_json <- function(opts) {
    json_data <- convert4corrwscatter(opts$data$data, opts$data$group, opts$params$reorder)

    json_data
}

get_data_as_json_file <- function(opts) {
    opts$data <- get_data_as_json(opts)
    json_file <- create_data_file(opts, "json")

    json_file
}

# Convert data to JSON format for corr_w_scatter vis
convert4corrwscatter <-
function(dat, group=NULL, reorder=TRUE)
{
  ind <- rownames(dat)
  variables <- colnames(dat)

  if(is.null(group))
    group <- rep(1, nrow(dat))

  if(nrow(dat) != length(group))
    stop("nrow(dat) != length(group)")
  if(!is.null(names(group)) && !all(names(group) == ind))
    stop("names(group) != rownames(dat)")

  if(reorder) {
    ord <- hclust(dist(t(dat)), method="ward")$order
    variables <- variables[ord]
    dat <- dat[,ord]
  }

  # correlation matrix
  corr <- cor(dat, use="pairwise.complete.obs")

  # get rid of names
  dimnames(corr) <- dimnames(dat) <- NULL
  names(group) <- NULL

  # data structure for JSON
  require(rjson)
  require(df2json)

  output <- list("ind" = toJSON(ind),
                 "var" = toJSON(variables),
                 "corr" = matrix2json(corr),
                 "dat" =  matrix2json(t(dat)), # columns as rows
                 "group" = toJSON(group))
  paste0("{", paste0("\"", names(output), "\" :", output, collapse=","), "}")
}
