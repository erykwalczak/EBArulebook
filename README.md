
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
European Banking Authority (EBA).

## Installation

You can install the released version of EBArulebook from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("EBArulebook")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("erzk/EBArulebook")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(EBArulebook)
```

    ## Loading required package: dplyr

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

    ## Loading required package: rvest

    ## Loading required package: xml2

## European Banking Authority - The Single Rulebook

Code in this repository was used to acquire and analyse data used in the
forthcoming Staff Working Paper. Check the vignette for more details.

### Get the full website

  - Run on Ubuntu 16.04

  - Install [phantomjs](https://github.com/ariya/phantomjs)

  - Write a simple
    [scraper](https://www.thedataschool.co.uk/brian-scally/web-scraping-javascript-content/)
    `scrape_EBA.js`:

This scraper was tested only on the Capital Requirements Regulation
(CRR) but it should also work on other parts of the rulebook.

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

  - “span” css selector gets all

The rulebook is also using simple html to display the rules and is
constructed in a simple
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
`parse_EBA_QA_page.R`

### Scraping

Scrape the actual Q\&As into a tabular form with `scrape_EBA_QA.R`
