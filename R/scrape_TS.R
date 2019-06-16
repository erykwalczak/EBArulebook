# # scrape technical standards
# library(dplyr)
# library(here)
# library(rvest)
# library(purrr)
#
# # load the EBA rulebook
# eba_rules <- scrape_EBA()
#
# # find technical standards
# ts_df <- eba_rules %>% dplyr::filter(ITS >= 1 |
#                             RTS >= 1 |
#                             ITS_QA >= 1 |
#                             RTS_QA >= 1 )
#
# # get URLs to technical standards when TS tag is provided
# # tested with ITS and RTS
# get_EBA_TS_url <- function(x, techstandard) {
#   rule <- x %>% xml2::read_html()
#
#   # get URLs of technical standards
#   ts_text <- rule %>% rvest::html_nodes(techstandard) %>% rvest::html_text()
#   ts_url <- ifelse(length(ts_text) == 0, NA,
#                     rule %>%
#                      rvest::html_nodes(techstandard) %>% # was: ".ITS"
#                      rvest::html_nodes("a") %>%
#                      rvest::html_attr("href") %>%
#                       paste0("https://eba.europa.eu", .))
#   # note: extraction fails when tags are embedded, e.g.
#   #
#   ts_regulatory_paper_url <-
#     ifelse(is.na(ts_url),
#            NA,
#            paste0(ts_url, "-/regulatory-activity/consultation-paper"))
#
#   scraped_ts <- data.frame(ts_text = ts_text,
#                            ts_url = ts_url,
#                            ts_regulatory_paper_url = ts_regulatory_paper_url,
#                            ts = techstandard,
#                            URL = x,
#                            stringsAsFactors = FALSE)
#   # clean URLs - in some cases "https://eba.europa.eu" is included in the URL
#   scraped_ts$ts_url <-
#     ifelse(
#       base::startsWith(scraped_ts$ts_url, "https://eba.europa.euhttps://www.eba.europa.eu"),
#       sub("^https://eba.europa.eu", "", scraped_ts$ts_url), # remove duplicated URL
#       scraped_ts$ts_url)
#
#   return(scraped_ts)
# }
#
# # test TS paper scraper
# paper_test <- get_EBA_TS_url(ts_df$URL[1], ".ITS") # scrape particular TS url (works with ITS-only tags)
#
# page_top <- paper_test$ts_url %>% xml2::read_html()
# content_page <- page_top %>% rvest::html_nodes(".journal-content-article") %>% rvest::html_text()
# # URLs to EURLex
# content_url <-
#   page_top %>%
#   rvest::html_nodes(".journal-content-article") %>%
#   rvest::html_nodes("a") %>%
#   rvest::html_attr("href") %>%
#   # keep only eur-lex URLs
#   purrr::keep(base::startsWith(., "http://eur-lex.europa.eu")) %>%
#   trimws()
#
# ## ^ turn into a function
# get_eurlex_links <- function(x) {
#
#   page_top <-
#     x %>%
#     xml2::read_html() # 'x' was 'paper_test$ts_url'
#
#   content_page <-
#     page_top %>%
#     rvest::html_nodes(".journal-content-article") %>%
#     rvest::html_text()
#
#   # URLs to EURLex
#   content_url <-
#     page_top %>%
#     rvest::html_nodes(".journal-content-article") %>%
#     rvest::html_nodes("a") %>%
#     rvest::html_attr("href") %>%
#     # keep only eur-lex URLs - OPTIONAL (otherwise it misses PDFs / zip files)
#     #purrr::keep(startsWith(., "http://eur-lex.europa.eu")) %>%
#     trimws()
#
#   eurlex_links <- data.frame(ts_url = x,
#                              ts_eurlex_url = content_url,
#                              stringsAsFactors = FALSE)
#   return(eurlex_links)
# }
#
#
# # currently works with html
# get_eurlex_content <- function(x) {
#   # GET TS
#   ts_page <-
#     x %>%
#     # IF 'x' = 'content_url[1]' THEN icon/text TS - this is the same in all ITS !!!
#     xml2::read_html()
#
#   # pull EURLex
#   ts_content <-
#     ts_page %>%
#     rvest::html_nodes("#text") %>%
#     rvest::html_text()
#
#   eurlex_df <-
#     data.frame(eurlex_url = x,
#                eurlex_content = ts_content,
#                stringsAsFactors = FALSE)
#   return(eurlex_df)
# }
#
#
# # this works too but it looks specific to a page !!! - TODO: fix/clean URL
# # page_top %>% html_nodes("#p_p_id_56_INSTANCE_f7GiX9dDGwOp_ .journal-content-article") %>% html_nodes("a") %>% html_attr("href")
#
# # there is a web service to access eur-lex
# # https://eur-lex.europa.eu/content/help/faq/reuse-contents-eurlex-details.html
# # API:
# # http://api.epdb.eu/eurlex/document/?id=32016R0100 - doesn't return correct doc (find where's ID)
# # https://www.r-bloggers.com/accessing-apis-from-r-and-a-little-r-programming/
#
# ### run on ALL TS ###
# ## ITS ##
# ts_its <- ts_df %>% dplyr::filter(ITS == 1)
# ts_links_its <- purrr::map_df(ts_its$URL, get_EBA_TS_url, ".ITS")
# #its_urls <- lapply(ts_links_its, `[[`, "ts_url") %>% unlist()
#
# # get links on the right-hand side of the TS pages (tested on ITS)
# its_eurlex_links <- purrr::map_df(ts_links_its$ts_url, get_eurlex_links)
# its_eurlex_links$type <- "ITS"
# # tests
# #its_eurlex1 <- get_eurlex_links(its_urls[1])
# #its_eurlex2 <- get_eurlex_links(its_urls[2])
#
# ## RTS ##
# # test RTS
# ts_rts <- ts_df %>% dplyr::filter(RTS >= 1)
# ts_links_rts <- purrr::map_df(ts_rts$URL, get_EBA_TS_url, ".RTS")
# # why 1:4 ts_links_rts is the same? - CORRECT - they are the same RTS
#
# # manually assign RTS url due to embedded URL in https://eba.europa.eu/regulation-and-policy/single-rulebook/interactive-single-rulebook/-/interactive-single-rulebook/toc/504/article-id/1484
# # there is QA tag within RTS and scraper pulls the QA link
# ts_links_rts$ts_url[25] <- "https://eba.europa.eu/regulation-and-policy/market-risk/draft-regulatory-technical-standards-rts-on-non-delta-risk-of-options-in-the-standardised-market-risk-approach"
# # otherwise fails here: rts_eurlex25 <- get_eurlex_links(ts_links_rts$ts_url[25])
#
# # get eurlex links
# rts_eurlex_links <- purrr::map_df(ts_links_rts$ts_url, get_eurlex_links)
# rts_eurlex_links$type <- "RTS"
#
# ### COMBINE ###
# ts_links <- dplyr::bind_rows(ts_links_its, ts_links_rts)
# ts_eurlex_links <- dplyr::bind_rows(its_eurlex_links, rts_eurlex_links)
#
# ### GET CONTENT of TS ###
# # check URL if 'legal-content' is present
# ts_eurlex_links$legal_content <- grepl("legal-content", ts_eurlex_links$ts_eurlex_url)
# ts_eurlex_links$pdf <- grepl("PDF", ts_eurlex_links$ts_eurlex_url)
# # keep only legal content
# ts_eurlex_links_legal <-
#   ts_eurlex_links %>%
#   filter(legal_content == 1,
#          pdf == 0)
#
# # get content from eurlex when legal-content present
# ts_eurlex_content <- purrr::map_df(ts_eurlex_links_legal$ts_eurlex_url, get_eurlex_content)
#
# ### SAVE ###
# # saveRDS(ts_links, here("data", "ts_links.Rds"))
# # saveRDS(ts_eurlex_links, here("data", "ts_eurlex_links.Rds"))
# # saveRDS(ts_eurlex_content, here("data", "ts_eurlex_content.Rds"))
