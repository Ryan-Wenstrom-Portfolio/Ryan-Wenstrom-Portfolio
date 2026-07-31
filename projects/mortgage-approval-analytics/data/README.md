# Data Notes

This project uses public 2017 Home Mortgage Disclosure Act mortgage application data from CFPB and FFIEC sources.

## Raw Data

Raw state level HMDA files are not stored directly in this repository because of file size and reproducibility considerations.

## Analytical Scope

* Year: 2017
* States: California, Illinois, Michigan, Texas
* Unit of analysis: mortgage application record
* Final analytical dataset: 205,000+ records

## Data Preparation

The project used Python during the initial preparation stage and Excel Power Query for the documented cleaning, filtering, recoding, and state level combination workflow.

## Interpretation Notes

Some fields describe the applicant or loan application, while other fields describe geographic or census tract context. These should not be treated as identical.

This project is designed for portfolio demonstration, business analysis, and data visualization. It should not be used to make lending, legal, or policy conclusions without deeper statistical and domain review.
