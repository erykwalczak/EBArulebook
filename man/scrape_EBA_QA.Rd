% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/scrape_EBA_QA.R
\name{scrape_EBA_QA}
\alias{scrape_EBA_QA}
\title{Get the content of the EBA single rulebook Q&As}
\usage{
scrape_EBA_QA(x)
}
\arguments{
\item{x}{String. Optional URL of Q&A to scrape.}
}
\value{
Data frame with the content of EBA rulebook Q&As.
}
\description{
The function first checks if scraped data is available locally.
If so, the Q&As are not scraped.
}
\examples{
\dontrun{
# return Q&As when saved locally
scrape_EBA_QA()
# when not saved locally Q&A will be scraped if URL is provided
scrape_EBA_QA("https://eba.europa.eu/single-rule-book-qa/-/qna/view/publicId/2019_4601")
}
}
