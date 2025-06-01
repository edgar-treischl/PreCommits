#!/usr/bin/env Rscript

"Style R files using tidyverse_style()

Usage:
  style-files.R [--check] [--verbose] [--strict] <files>...

Options:
  --check    Only check if files need styling; don't modify them.
  --verbose  Print detailed output.
  --strict   Fail with error code if any files need styling.
  <files>    One or more .R files to style.
" -> doc

library(docopt)
library(styler)

args <- docopt::docopt(doc)

files <- args$files
check_mode <- args$check
verbose <- args$verbose
strict <- args$strict

# This function checks if a file needs styling by comparing original and styled code
needs_styling <- function(file) {
  original <- readLines(file, warn = FALSE)
  styled <- styler:::style_text(paste(original, collapse = "\n"), style = styler::tidyverse_style)
  !identical(paste(original, collapse = "\n"), paste(styled, collapse = "\n"))
}

files_needing_style <- character(0)

if (check_mode) {
  # Just check files, don't write changes
  for (f in files) {
    if (needs_styling(f)) {
      files_needing_style <- c(files_needing_style, f)
      if (verbose) {
        message("Needs styling: ", f)
      }
    } else if (verbose) {
      message("OK: ", f)
    }
  }

  if (strict && length(files_needing_style) > 0) {
    message("\nStyling issues found in ", length(files_needing_style), " file(s). Commit failed.")
    quit(status = 1)
  }
} else {
  # Style files in place
  for (f in files) {
    if (verbose) message("Styling file: ", f)
    styler::style_file(f, style = styler::tidyverse_style)
  }
}

# Exit cleanly
quit(status = 0)
