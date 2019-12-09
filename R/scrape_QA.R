# scrape Q&A
library(dplyr)
library(rvest)
library(purrr)
library(EBArulebook)

# load the EBA rulebook
eba_rules <- scrape_EBA()

#clean EBA rule
eba_rules$URL_clean <- gsub("-/interactive-single-rulebook/toc/504/article-id/", "", eba_rules$URL)

# find technical standards
qa_df <- eba_rules %>% dplyr::filter(QA >= 1)

source("./R/get_qa.R")
#%%%%%%%%%% SCRAPING %%%%%%%%%%%%%%%%%


# map the function
qa_all_df <- purrr::map_dfr(qa_df$URL_clean, get_qa)

# other selectors
its_qa_selector <- ".ITSqa a"
rts_qa_selector <- ".RTSqa a"
gl_qa_selector <- ".GLqa a"
da_qa_selector <- ".DAqa a"

# scrape the remaining Q&As
its_qa_all_df <- purrr::map_dfr(eba_rules %>%
                                dplyr::filter(ITS_QA >= 1) %>%
                                pull(URL_clean),
                                get_qa,
                                qa_selector = its_qa_selector,
                                QA_type = "ITS_Q&A")

rts_qa_all_df <- purrr::map_dfr(eba_rules %>%
                                dplyr::filter(RTS_QA >= 1) %>%
                                pull(URL_clean),
                                get_qa,
                                qa_selector = rts_qa_selector,
                                QA_type = "RTS_Q&A")

gl_qa_all_df <- purrr::map_dfr(eba_rules %>%
                                dplyr::filter(GL_QA >= 1) %>%
                                pull(URL_clean),
                                get_qa,
                                qa_selector = gl_qa_selector,
                                QA_type = "GL_Q&A")

da_qa_all_df <- purrr::map_dfr(eba_rules %>%
                                dplyr::filter(DA_QA >= 1) %>%
                                pull(URL_clean),
                                get_qa,
                                qa_selector = da_qa_selector,
                                QA_type = "DA_Q&A")
# combine all scraped data
all_scraped_qa <-
  bind_rows(qa_all_df,
            its_qa_all_df,
            rts_qa_all_df,
            gl_qa_all_df,
            da_qa_all_df)

# %%%%%%%%%%%%%%%%%% CLEANING %%%%%%%%%%%%%%%%%%%%%%%%%%%%
# clean Q&A IDs
# single Q&A IDs:
extract_qa_id <- function(x) {
  a <- gsub("^.*/publicId/", "", x)
  b <- gsub("\\?.*$", "", a)
  c <- gsub("%20", "", b) # clean several messy entries
  return(c)
}

all_scraped_qa$qa_id <-
  ifelse(
    # if contains "view/publicId/"
    grepl("/publicId/", all_scraped_qa$qa_url),
    # then remove everything before the last '/'
    extract_qa_id(all_scraped_qa$qa_url),
    #gsub(".*/", "", all_scraped_qa$qa_url),
    NA
  )

