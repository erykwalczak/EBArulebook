#' Get the content of the EBA single rulebook
#'
#' The function first checks if scraped data is available locally.
#' If so, the rulebook is not scraped.
#'
#' @param x String. Optional URL of rules to scrape.
#'
#' @return Data frame with the content of EBA rulebook.
#' Additional columns (QA to DA_QA) counts the number of occurrences of tags.
#' @export
#'
#' @examples
#' \dontrun{
#' # when rulebook URLs are saved locally
#' scrape_EBA()
#' # if not, rules will be scraped when URL is provided
#' scrape_EBA("https://eba.europa.eu/regulation-and-policy/single-rulebook/interactive-single-rulebook/-/interactive-single-rulebook/toc/504/article-id/601")
#' }
scrape_EBA <- function(x) {

  # check if the file exists locally to avoid scraping
  all_eba_rules_path <- here::here("data", "all_eba_rules.Rds")
  if (file.exists(all_eba_rules_path)) {
    all_eba_rules <- readRDS(all_eba_rules_path)
    return(all_eba_rules)
  }

  # if the file cannot be found locally then scrape Q&As
  else {
    # show progress
    cat(".")
    # scrape top page - go through clean URLs
    # pull the main data from the EBA rulebook
    rule <- x %>% read_html()

    # main content
    # pull ".aui-w20" (type) and ".aui-w80" (text) columns
    a <- rule %>% html_nodes(".aui-w20") %>% html_text()
    b <- rule %>% html_nodes(".aui-w80") %>% html_text()

    rule_df <- data.frame(Text = t(b))
    colnames(rule_df) <- a

    # clean the path name
    rule_df$Path <- gsub(" \\(Copy link to article\\)", "", rule_df$Path)

    # additional tags
    qa <- rule %>% html_nodes(".QandA") %>% length()
    its <- rule %>% html_nodes(".ITS") %>% length()
    its_qa <- rule %>% html_nodes(".ITSqa") %>% length()
    rts <- rule %>% html_nodes(".RTS") %>% length()
    rts_qa <- rule %>% html_nodes(".RTSqa") %>% length()
    gl <- rule %>% html_nodes(".GL") %>% length()
    gl_qa <- rule %>% html_nodes(".GLqa") %>% length()
    da_qa <- rule %>% html_nodes(".DAqa") %>% length()

    # append the data frame
    rule_df$URL = x
    rule_df$QA = qa
    rule_df$ITS = its
    rule_df$ITS_QA = its_qa
    rule_df$RTS = rts
    rule_df$RTS_QA = rts_qa
    rule_df$GL = gl
    rule_df$GL_QA = gl_qa
    rule_df$DA_QA = da_qa

    return(rule_df)
    }
}
