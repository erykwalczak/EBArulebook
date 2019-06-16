#' Parse EBA Q&A pages
#'
#' @return Data frame with Q&A Title (Subject Matter) and corresponding URL
#' @export
#'
#' @examples
#' parse_EBA_QA_page()
parse_EBA_QA_page <- function() {
  # load the html
  eba_pages <- list.files(here::here("data"),
                          pattern = "^website_EBA_QA")
  eba_pages <- here::here("data", eba_pages)

  # create an empty data frame
  qa_total = data.frame()

  for (i in eba_pages) {
    print(i)

    # load QA page
    eba_page <- xml2::read_html(i)

    # pull all IDs - this will make it easy to scrape regular Q&As as they have a simple format
    # phantonJS scraped website contains questionID but I need publicID (that's what's used in clean URLs)
    qa <- eba_page %>% rvest::html_nodes("p a")

    # create a data frame
    qa_df <-
      data.frame(
        Title = qa %>% rvest::html_text(),
        URL = qa %>% rvest::html_attr("href"),
        stringsAsFactors = FALSE)

    # trim
    # only keep the rows that contain "_questionId"
    qa_df$Article <- stringr::str_detect(qa_df$URL, "_questionId=")

    qa_df <- qa_df %>% dplyr::filter(qa_df$Article == TRUE)
    qa_df <- qa_df %>% dplyr::filter(Title != "")

    # append
    qa_total <- rbind(qa_total, qa_df)
  }

  # clean
  rm(qa, qa_df, eba_page)
  qa_total$Article <- NULL

  # return cleaned data frame
  return(qa_total)
}

# saveQAs
#saveRDS(qa_total, here::here("data", "EBA_QA.Rds"))
