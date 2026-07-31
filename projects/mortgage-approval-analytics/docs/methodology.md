# Methodology

## Project Objective

The objective of this project was to explore how favorable mortgage application decisions varied across applicant, financial, geographic, and property characteristics in selected 2017 HMDA records from California, Illinois, Michigan, and Texas.

## Data Source

The project used public 2017 Home Mortgage Disclosure Act data from CFPB and FFIEC sources.

## Analytical Scope

- Year: 2017
- States: California, Illinois, Michigan, Texas
- Unit of analysis: mortgage application record
- Final analytical dataset: 205,000+ records
- Main outcome: favorable mortgage decision

## Workflow

1. Collected state-level HMDA mortgage application files.
2. Used Python during the initial data preparation stage.
3. Used Excel Power Query to clean, recode, filter, and combine the state-level data.
4. Created analysis fields for approval status, applicant income groups, loan to income ratios, and demographic segments.
5. Built Tableau dashboards to compare approval patterns across geography, income, applicant groups, and property types.
6. Communicated findings through a written report and presentation.

## Key Transformations

The data preparation process included:

- Filtering application records to focus on relevant mortgage decision outcomes.
- Creating an approval status field for favorable mortgage decisions.
- Grouping applicant income into interpretable ranges.
- Creating loan to income ratio fields.
- Combining applicant race and gender categories for subgroup analysis.
- Reducing source fields into a focused analytical dataset for dashboarding.

## Dashboard Design

The Tableau dashboards were designed to support exploratory analysis. The dashboard sequence moved from broad approval patterns to more detailed subgroup and property-type comparisons.

The design goal was to make differences visible without overstating what the data could prove.

## Interpretation Standard

This project identifies patterns in mortgage application outcomes. It does not prove causality, discrimination, or individual loan decision logic. The findings are best interpreted as signals for deeper review.
