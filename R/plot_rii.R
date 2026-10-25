#' Plot a ranked RII bar chart
#'
#' Produces a horizontal bar chart of RII values, sorted from highest to
#' lowest, in the style typically used to report RII results in
#' environmental, construction and social science papers. Uses only base R
#' graphics, so it needs no extra packages. If the plotting window is
#' small, it automatically tries progressively more compact label sizes
#' and margins rather than failing outright with a "figure margins too
#' large" error, which is a common base-R issue with long item names in a
#' small plot pane.
#'
#' @param x An object of class \code{"rii_table"} (see
#'   \code{\link{rii_table}} or \code{\link{rii_table_freq}}).
#' @param top_n Optional integer; if given, only the top \code{top_n} items
#'   are plotted. Defaults to all items.
#' @param col Bar colour. Defaults to a green shade referencing the
#'   Nigerian flag, since the bundled example dataset is Nigerian; change
#'   freely for other contexts.
#' @param main Plot title. Defaults to \code{"Relative Importance Index"}.
#' @param show_values Logical; print the RII value at the end of each bar?
#'   Defaults to \code{TRUE}.
#' @param max_label_chars Maximum number of characters to show for each
#'   item label before truncating with "..."; also caps how wide the left
#'   margin can grow. Defaults to 28. This is only a starting point — if
#'   the plotting window is too small even for this, smaller values (and a
#'   smaller \code{cex.names}) are tried automatically before giving up.
#' @param cex.names Starting character expansion for the item labels,
#'   passed to \code{\link[graphics]{barplot}}. Also only a starting
#'   point when the window is small; see \code{max_label_chars}.
#' @param pretty_labels Logical; if \code{TRUE} (default), item names written
#'   as CamelCase or with underscores/dots (e.g. \code{"SubstandardMaterials"},
#'   \code{"Q1_Notify_Staff"}) are split into separate words for display
#'   (\code{"Substandard Materials"}). Names that already contain spaces are
#'   left unchanged. Set to \code{FALSE} to show names exactly as stored.
#' @param wrap_width Maximum characters per line before an item label is
#'   wrapped onto a new line. Defaults to 22.
#' @param ... Further arguments passed on to \code{\link[graphics]{barplot}}.
#'
#' @return Invisibly, the bar midpoints returned by
#'   \code{\link[graphics]{barplot}}.
#'
#' @examples
#' data(building_collapse_nigeria)
#' tbl <- rii_table(building_collapse_nigeria[, 5:14])
#' plot(tbl)
#' plot(tbl, top_n = 5, col = "steelblue")
#'
#' @export
plot.rii_table <- function(x, top_n = NULL, col = "#008751",
                            main = "Relative Importance Index",
                            show_values = TRUE, max_label_chars = 28,
                            cex.names = 1, pretty_labels = TRUE,
                            wrap_width = 22, ...) {
  d <- x[order(x$Rank), ]
  if (!is.null(top_n)) d <- d[seq_len(min(top_n, nrow(d))), ]
  # Plot with the top-ranked item at the top of the chart
  d <- d[rev(seq_len(nrow(d))), ]

  items <- as.character(d$Item)
  if (isTRUE(pretty_labels)) items <- prettify_item_names(items)

  # Wrap each label onto several lines (at most `width` characters per
  # line), then truncate any single over-long word with "...".
  make_labels <- function(chars) {
    width <- max(5, min(wrap_width, chars))
    vapply(items, function(s) {
      lines <- strwrap(s, width = width)
      if (length(lines) == 0) lines <- ""
      lines <- ifelse(nchar(lines) > chars,
                      paste0(substr(lines, 1, chars - 3), "..."),
                      lines)
      paste(lines, collapse = "\n")
    }, character(1), USE.NAMES = FALSE)
  }

  draw_once <- function(chars, mult, cex_n, check_fit = TRUE) {
    labels <- make_labels(chars)
    longest_line <- max(nchar(unlist(strsplit(labels, "\n", fixed = TRUE))))
    mar_left <- longest_line * mult + 4
    # Reject a label margin that would squeeze the bars into a sliver on a
    # small device, so the next, more compact attempt is used instead.
    if (check_fit) {
      avail <- 0.45 * graphics::par("din")[1] / graphics::par("csi")
      if (mar_left > avail) stop("label margin too wide for device")
    }
    op <- graphics::par(mar = c(5, mar_left, 4, 3))
    on.exit(graphics::par(op))

    bp <- graphics::barplot(
      d$RII, names.arg = labels, horiz = TRUE, las = 1, col = col,
      border = NA, xlim = c(0, 1), xlab = "RII", main = main,
      cex.names = cex_n, ...
    )
    graphics::abline(v = seq(0, 1, by = 0.2), col = "grey85", lty = 3)
    graphics::barplot(d$RII, names.arg = labels, horiz = TRUE, las = 1,
                       col = col, border = NA, xlim = c(0, 1),
                       xlab = "RII", main = main, cex.names = cex_n,
                       add = TRUE)
    if (show_values) {
      graphics::text(d$RII + 0.02, bp, labels = sprintf("%.3f", d$RII),
                      adj = 0, cex = 0.8 * cex_n, xpd = NA)
    }
    bp
  }

  # Progressively more compact fallbacks for small plotting windows: each
  # step shortens labels and shrinks text further than the last.
  attempts <- list(
    c(chars = max_label_chars,               mult = 0.55, cex = cex.names),
    c(chars = min(max_label_chars, 20),       mult = 0.45, cex = cex.names * 0.85),
    c(chars = min(max_label_chars, 15),       mult = 0.38, cex = cex.names * 0.7),
    c(chars = min(max_label_chars, 10),       mult = 0.32, cex = cex.names * 0.6)
  )

  bp <- NULL
  last_error <- NULL
  for (i in seq_along(attempts)) {
    a <- attempts[[i]]
    bp <- tryCatch(
      draw_once(a[["chars"]], a[["mult"]], a[["cex"]],
                check_fit = i < length(attempts)),
      error = function(e) { last_error <<- e; NULL }
    )
    if (!is.null(bp)) break
  }

  if (is.null(bp)) {
    stop(
      "Could not draw the plot (", conditionMessage(last_error), "). ",
      "The plotting window is too small even after shrinking labels. ",
      "Try enlarging the plot window/device (e.g. RStudio's Plots pane), ",
      "or lower max_label_chars/cex.names further yourself, e.g. ",
      "plot(tbl, max_label_chars = 8, cex.names = 0.5).",
      call. = FALSE
    )
  }
  invisible(bp)
}

# Split CamelCase / snake_case / dotted item names into spaced words for
# display. Names that already contain spaces are returned untouched.
#' @noRd
prettify_item_names <- function(x) {
  vapply(x, function(s) {
    if (is.na(s) || grepl(" ", s, fixed = TRUE)) return(s)
    s <- gsub("[._]+", " ", s)
    s <- gsub("([a-z0-9])([A-Z])", "\\1 \\2", s)
    s <- gsub("([A-Z]+)([A-Z][a-z])", "\\1 \\2", s)
    trimws(gsub("\\s+", " ", s))
  }, character(1), USE.NAMES = FALSE)
}
