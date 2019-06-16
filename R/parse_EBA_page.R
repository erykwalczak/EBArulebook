#' Parse EBA rulebook page
#'
#' @return Data frame with Title/Scope, URL, and Rule ID (extracted from URLs)
#' @export
#'
#' @examples
#' parse_EBA_page()
parse_EBA_page <- function() {
  # load the html
  eba_page <- here::here("data", "website_phantom.html")
  eba_page <- xml2::read_html(eba_page)
  articles <- eba_page %>% rvest::html_nodes("a")

  # create a DF
  articles_df <-
    data.frame(
      Title = articles %>% html_text(),
      URL = articles %>% html_attr("href"),
      stringsAsFactors = FALSE)

  # trim
  # only keep the rows that contain "article-id"
  articles_df$Article <- stringr::str_detect(articles_df$URL, "article-id")

  articles_df <- articles_df %>% dplyr::filter(articles_df$Article == TRUE)
  articles_df <- articles_df %>% dplyr::filter(Title != "")

  # get clean URL
  articles_df$URL <- gsub(";.*$", "", articles_df$URL)

  # get the IDs
  articles_df$ID <- gsub("^.*article-id/", "", articles_df$URL)

  # clean
  rm(articles, eba_page)
  articles_df$Article <- NULL
  articles_df$Title <- trimws(articles_df$Title)

  # return cleaned data frame
  return(articles_df)
}
