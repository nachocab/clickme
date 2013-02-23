start_server <- function(base, appname = "clickme", browse = interactive()) {
  stopifnot(file.exists(base), file.info(base)$isdir)
  base <- normalizePath(base)

  server <- Rhttpd$new()
  server$add(make_router(base), appname)
  server$start(quiet = TRUE)

  if (browse) server$browse(appname)
  invisible(server)
}