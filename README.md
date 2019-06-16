
# EBArulebook

<!-- badges: start -->

[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable)
[![CRAN
status](https://www.r-pkg.org/badges/version/EBArulebook)](https://cran.r-project.org/package=EBArulebook)
<!-- badges: end -->

The goal of EBArulebook is to scrape the [single
rulebook](https://eba.europa.eu/regulation-and-policy/single-rulebook)
and [Q\&As](https://eba.europa.eu/single-rule-book-qa) published by the
European Banking Authority (EBA). This package was developed while
working on a Staff Working Paper.

If you use this package, then please cite it.

## Installation

You can install the development version of EBArulebook from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("erzk/EBArulebook")
```

## Examples

This packages makes it easy to obtain EBA data in a tabular form

``` r
library(EBArulebook)
```

To get **EBA single rulebook** (tested only on Capital Requirements
Regulation (*CRR*))

``` r
all_eba_rules <- scrape_EBA()

dplyr::glimpse(all_eba_rules)
```

    ## Observations: 530
    ## Variables: 14
    ## $ Path           <chr> "Capital Requirements Regulation > Recital", "Cap…
    ## $ Title          <chr> "Recital", "Article 1", "Article 2", "Article 3",…
    ## $ Description    <chr> "Recital", "Scope", "Supervisory powers", "Applic…
    ## $ `Main content` <chr> " THE EUROPEAN PARLIAMENT AND THE COUNCIL OF THE …
    ## $ Topics         <chr> "", "", "", "", "Own funds ; Other topics ; Large…
    ## $ URL            <chr> "https://eba.europa.eu/regulation-and-policy/sing…
    ## $ QA             <int> 0, 0, 0, 0, 9, 0, 1, 0, 2, 1, 0, 3, 0, 3, 0, 0, 0…
    ## $ ITS            <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
    ## $ ITS_QA         <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
    ## $ RTS            <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
    ## $ RTS_QA         <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
    ## $ GL             <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
    ## $ GL_QA          <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
    ## $ DA_QA          <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…

To get **EBA single rulebook Q\&As**

``` r
qa_df <- scrape_EBA_QA()

dplyr::glimpse(qa_df)
```

    ## Observations: 1,757
    ## Variables: 24
    ## $ `Question ID`                                    <chr> "2019_4601", "2…
    ## $ `Legal act`                                      <chr> "Directive 2015…
    ## $ Topic                                            <chr> "Strong custome…
    ## $ Article                                          <chr> "46", "97", "97…
    ## $ Paragraph                                        <chr> "a", "1", "", "…
    ## $ Subparagraph                                     <chr> "", "", "", "c"…
    ## $ `Article/Paragraph`                              <chr> "Article 36(1) …
    ## $ `COM Delegated or Implementing Acts/RTS/ITS/GLs` <chr> "Regulation (EU…
    ## $ `Name of institution / submitter`                <chr> "Reflow - Manis…
    ## $ `Country of incorporation / residence`           <chr> "UK", "Germany"…
    ## $ `Type of submitter`                              <chr> "Other", "Compe…
    ## $ `Subject matter`                                 <chr> "ASPSP providin…
    ## $ Question                                         <chr> "Are account se…
    ## $ `Background on the question`                     <chr> "The purpose of…
    ## $ `Date of submission`                             <chr> "11/03/2019", "…
    ## $ `Published as Final Q&A`                         <chr> "07/06/2019", "…
    ## $ `EBA answer`                                     <chr> "The submitter …
    ## $ Status                                           <chr> "Final Q&A", "F…
    ## $ `Permanent link`                                 <chr> "https://eba.eu…
    ## $ ProvidedURL                                      <chr> "https://eba.eu…
    ## $ QA_links                                         <chr> "https://eba.eu…
    ## $ Attachments                                      <chr> NA, NA, NA, NA,…
    ## $ `Published as Rejected Q&A`                      <chr> NA, NA, NA, NA,…
    ## $ `Rationale for rejection`                        <chr> NA, NA, NA, NA,…

## European Banking Authority - The Single Rulebook

Code in this repository was used to acquire and analyse data used in the
forthcoming Staff Working Paper.

Check the
[vignettes](https://github.com/erzk/EBArulebook/tree/master/vignettes)
for more details and examples.

### Get the full website

  - Install [phantomjs](https://github.com/ariya/phantomjs)

  - Write a simple
    [scraper](https://www.thedataschool.co.uk/brian-scally/web-scraping-javascript-content/)
    `scrape_EBA.js`:

This scraper was developed on Ubuntu 16.04. It was tested only on the
Capital Requirements Regulation (CRR) but it should also work on other
parts of the EBA rulebook.

The EBA rulebook is displayed dynamically so the first step is to scrape
the text using a headless browser
(phantomjs).

``` r
var url = 'https://eba.europa.eu/regulation-and-policy/single-rulebook/interactive-single-rulebook/-/interactive-single-rulebook/toc/504'; 

var page = new WebPage(); 
var fs = require('fs'); 

page.open(url, function (status) { 
just_wait(); }); 

function just_wait() { 
setTimeout(function() { 
fs.write('website_phantom.html', 
page.content, 'w'); 
phantom.exit(); }, 2500); 
}
```

  - Run the scraper from the command line with

<!-- end list -->

``` bash
phantomjs scrape_EBA.js
```

This downloads the entire page which then needs to be cleaned.

### Parse downloaded html pages

  - Analyse the output `website_phantom.html`

  - Use `rvest` to extract key data

The rulebook is using html to display the rules and is constructed in a
simple
way:

<https://eba.europa.eu/regulation-and-policy/single-rulebook/interactive-single-rulebook/-/interactive-single-rulebook/article-id/2002>

where the last number after ‘/’ is an id.

There are two solutions to this problem:

1.  Brute force scrape all numbers until nothing is pulled
2.  Extract the relevant numbers by running regex on the scraped html
    file. Look for the IDs: “article-id/\[DIGIT\]”

Here solution 2. was used. See `parse_EBA_page()`.

## Q\&As

### Scraper

Search for questions. There are 1757 Q\&As (1652 Final and 105 Rejected)
as of 8 June 2019. Max displayed per page is 200 (end of the URL) so 9
pages in total (see: ‘cur=2’ in the URL)

Use `scrape_EBA_QA.js` from the command line

``` bash
phantomjs scrape_EBA.js
```

Edit the .js file updating the pages to scrape:

Page
1:

<https://eba.europa.eu/single-rule-book-qa?p_p_id=questions_and_answers_WAR_questions_and_answersportlet&p_p_lifecycle=0&p_p_state=normal&p_p_mode=view&p_p_col_id=column-1&p_p_col_pos=1&p_p_col_count=2&_questions_and_answers_WAR_questions_and_answersportlet_keywords=&_questions_and_answers_WAR_questions_and_answersportlet_advancedSearch=false&_questions_and_answers_WAR_questions_and_answersportlet_andOperator=true&_questions_and_answers_WAR_questions_and_answersportlet_jspPage=%2Fhtml%2Fview.jsp&_questions_and_answers_WAR_questions_and_answersportlet_statusSearch=All&_questions_and_answers_WAR_questions_and_answersportlet_viewTab=1&_questions_and_answers_WAR_questions_and_answersportlet_keyword=&_questions_and_answers_WAR_questions_and_answersportlet_articleSearch=&_questions_and_answers_WAR_questions_and_answersportlet_typeOfSubmitterSearch=&_questions_and_answers_WAR_questions_and_answersportlet_publicIdSearch=&_questions_and_answers_WAR_questions_and_answersportlet_startingDateSearch=&_questions_and_answers_WAR_questions_and_answersportlet_endingDateSearch=&_questions_and_answers_WAR_questions_and_answersportlet_applicableFromDate=&_questions_and_answers_WAR_questions_and_answersportlet_applicableUntilDate=&_questions_and_answers_WAR_questions_and_answersportlet_publicationFromDateSearch=&_questions_and_answers_WAR_questions_and_answersportlet_publicationToDateSearch=&_questions_and_answers_WAR_questions_and_answersportlet_currentTab=All&_questions_and_answers_WAR_questions_and_answersportlet_resetCur=false&_questions_and_answers_WAR_questions_and_answersportlet_delta=200>

Status: use ‘All’: both ‘Final’ and
‘Rejected’

<https://eba.europa.eu/single-rule-book-qa?p_p_id=questions_and_answers_WAR_questions_and_answersportlet&p_p_lifecycle=0&p_p_state=normal&p_p_mode=view&p_p_col_id=column-1&p_p_col_pos=1&p_p_col_count=2&_questions_and_answers_WAR_questions_and_answersportlet_delta=200&_questions_and_answers_WAR_questions_and_answersportlet_keywords=&_questions_and_answers_WAR_questions_and_answersportlet_advancedSearch=false&_questions_and_answers_WAR_questions_and_answersportlet_andOperator=true&_questions_and_answers_WAR_questions_and_answersportlet_jspPage=%2Fhtml%2Fview.jsp&_questions_and_answers_WAR_questions_and_answersportlet_statusSearch=All&_questions_and_answers_WAR_questions_and_answersportlet_viewTab=1&_questions_and_answers_WAR_questions_and_answersportlet_keyword=&_questions_and_answers_WAR_questions_and_answersportlet_articleSearch=&_questions_and_answers_WAR_questions_and_answersportlet_typeOfSubmitterSearch=&_questions_and_answers_WAR_questions_and_answersportlet_publicIdSearch=&_questions_and_answers_WAR_questions_and_answersportlet_startingDateSearch=&_questions_and_answers_WAR_questions_and_answersportlet_endingDateSearch=&_questions_and_answers_WAR_questions_and_answersportlet_applicableFromDate=&_questions_and_answers_WAR_questions_and_answersportlet_applicableUntilDate=&_questions_and_answers_WAR_questions_and_answersportlet_publicationFromDateSearch=&_questions_and_answers_WAR_questions_and_answersportlet_publicationToDateSearch=&_questions_and_answers_WAR_questions_and_answersportlet_currentTab=All&_questions_and_answers_WAR_questions_and_answersportlet_resetCur=false&_questions_and_answers_WAR_questions_and_answersportlet_cur=2>

This will generate 9 html pages with max 200 Q\&As. These scraped pages
need to be then processed.

### Parsing

Extract URL to the actual questions from the downloaded website using
`parse_EBA_QA_page()`

### Scraping

Scrape the actual Q\&As into a tabular form with `scrape_EBA_QA()`
