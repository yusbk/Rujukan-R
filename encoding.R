try_encoding <- function(x) {
  if (missing(x)) stop("'x' is missing")
  z <- tryCatch(Encoding(x), error = function(e) e)
  if (inherits(z, "error")) "ASCII-8BIT" else z
}

Encoding_safe <- function(x) {
  tryenc <- tryCatch(Encoding(x), error = function(e) e)
  if (inherits(tryenc, "error")) "unknown" else tryenc
}

txx <- "Åsøkæm"
try_encoding(txx)
Encoding(txx)
Encoding("\u00f6")
print("S\u00f6k")

## Ref https://github.com/sykdomspulsen-org/sc/blob/8b2243e92b9050f1fb87bb2fd01fb61a1faa3488/R/util_latin1_to_utf8.R
#' latin1_to_utf8
#' Takes a data.frame and converts it to utf8
#' @param df data.frame to convert
#' @export
latin1_to_utf8 <- function(df) {
  setDT(df)
  for (i in names(df)) {
    try(if ("UTF-8" %in% Encoding(df[[i]])) df[, (i) := iconv(get(i), from = "latin1", to = "utf8")], TRUE)
  }
  return(df)
}
