#' Get the content of the EBA single rulebook Q&As
#'
#' The function first checks if scraped data is available locally.
#' If so, the Q&As are not scraped.
#'
#' @param x String. Optional URL of Q&A to scrape.
#'
#' @return Data frame with the content of EBA rulebook Q&As.
#' @export
#'
#' @examples
#'\dontrun{
#' # return Q&As when saved locally
#' scrape_EBA_QA()
#' # when not saved locally Q&A will be scraped if URL is provided
#' scrape_EBA_QA("https://eba.europa.eu/single-rule-book-qa/-/qna/view/publicId/2019_4601")
#' }
scrape_EBA_QA <- function(x) {

  # check if the file exists locally to avoid scraping
  all_QAs_path <- here::here("data", "qa_df.Rds")
  if (file.exists(all_QAs_path)) {
    qa_df <- readRDS(all_QAs_path)
    return(qa_df)
  }
  # if the file cannot be found locally then scrape Q&As
  else {

    # show progress
    cat(".")
    # scrape top page
    rule <- x %>% xml2::read_html()

    ### main content
    # left column
    a <- rule %>% rvest::html_nodes(".aui-w25")
    a_text <- a %>% rvest::html_text() %>% trimws() %>% sub(":$", "", .) %>% trimws()
    # get the permanent link
    a_perm_link <- rule %>% rvest::html_nodes(".aui-w75 > a") %>% rvest::html_attr("href")
    # links in the text body - tag 'p' covers rows 'Question', 'Background' and 'EBA answer'
    a_links <-
      rule %>%
      rvest::html_nodes("p a") %>%
      rvest::html_attr("href") %>%
      unlist() %>%
      paste(., collapse = " ") # turn into one vector separated by whitespace

    # right column
    b <- rule %>% rvest::html_nodes(".aui-w75")
    b_text <- b %>% rvest::html_text() %>% trimws()

    qa_df <- data.frame(Text = t(b_text))
    colnames(qa_df) <- a_text

    # assign extracted hyperlinks
    qa_df$ProvidedURL <- x # provided URL
    qa_df$`Permanent link` <- a_perm_link # permanent link - clean link to the Q&A
    qa_df$QA_links <- a_links

    return(qa_df)
  }
}
