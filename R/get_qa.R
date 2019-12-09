# x - String. URL to scrape
#' Get Q&A info from CRR
#'
#' @param x String. CRR URL to scrape.
#' @param qa_selector String. CSS selector to scrape. Options: ".ITSqa a", ".RTSqa a", ".GLqa a", ".DAqa a".
#' @param QA_type String. Description of the scraped data. Added to the output
#'
#' @return Data frame with the provided CRR URL, URL of Q&As, content of the paragraph with Q&A, type of Q&A.
#' @export
#'
#' @examples
#' get_qa("https://eba.europa.eu/regulation-and-policy/single-rulebook/interactive-single-rulebook/2404")
get_qa <- function(x, qa_selector = ".QandA a", QA_type = "Q&A") {
  print(paste("Scraping CRR:", x))

  page_top <-
    x %>%
    xml2::read_html()

# extract the text
  content_page <-
    page_top %>%
    rvest::html_nodes(qa_selector) %>%
    rvest::html_text()

  # extract the URLs
  content_url <-
    page_top %>%
    rvest::html_nodes(qa_selector) %>%
    rvest::html_attr("href") %>%
    trimws()

  # put extracted data into data frame
  qa_scraped <-
    data.frame(
      crr_url = x,
      crr_text = content_page,
      qa_url = content_url,
      qa_type = QA_type,
      stringsAsFactors = FALSE)

  return(qa_scraped)
}
