# opts$data = data matrix [p x n]
# opts$qu = quantiles in (0, 0.5), e.g. (0.01, 0.05, 0.25)
# opts$orderByMedian = TRUE/FALSE indicating whether to order by medians
# opts$breaks = number or vector of histogram breaks
get_data_as_json <- function(opts) {
    json_data <- convert4manyboxplots(opts$data, opts$params$qu, opts$params$orderByMedian, opts$params$breaks)

    json_data
}

get_data_as_json_file <- function(opts) {
    opts$data <- get_data_as_json(opts)
    json_file <- create_data_file(opts, "json")

    json_file
}

# Convert data for large matrix to JSON format for manyboxplots vis
convert4manyboxplots <-
function(dat, qu = c(0.001, 0.01, 0.1, 0.25), orderByMedian=TRUE,
         breaks=251)
{
  if(is.null(colnames(dat)))
    colnames(dat) <- paste0(1:ncol(dat))

  if(orderByMedian)
    dat <- dat[,order(apply(dat, 2, median, na.rm=TRUE))]

  # check quantiles
  if(any(qu <= 0)) {
    warning("qu should all be > 0")
    qu <- qu[qu > 0]
  }

  if(any(qu >= 0.5)) {
    warning("qu should all by < 0.5")
    qu <- qu[qu < 0.5]
  }

  qu <- c(qu, 0.5, rev(1-qu))
  quant <- apply(dat, 2, quantile, qu, na.rm=TRUE)

  # counts for histograms
  if(length(breaks) == 1)
    breaks <- seq(min(dat, na.rm=TRUE), max(dat, na.rm=TRUE), length=breaks)

  counts <- apply(dat, 2, function(a) hist(a, breaks=breaks, plot=FALSE)$counts)

  ind <- colnames(dat)

  dimnames(quant) <- dimnames(counts) <- NULL

  # data structure for JSON
  require(rjson)
  require(df2json)
  output <- list("ind" = toJSON(ind),
                 "qu" = toJSON(qu),
                 "breaks" = toJSON(breaks),
                 "quant" = matrix2json(quant),
                 "counts" = matrix2json(t(counts)))
  paste0("{", paste0("\"", names(output), "\" :", output, collapse=","), "}")
}
