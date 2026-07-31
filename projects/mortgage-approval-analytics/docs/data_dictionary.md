# Data Dictionary

This project uses selected fields from 2017 HMDA mortgage application records. The final analytical dataset was created from public CFPB/FFIEC HMDA state files and cleaned for dashboard analysis.

## Core Fields

| Field | Description |
|---|---|
| State | State where the mortgage application was recorded |
| County | County associated with the application record |
| Loan Amount | Reported mortgage loan amount |
| Applicant Income | Reported applicant income |
| Loan to Income Ratio | Loan amount divided by applicant income |
| Approval Status | Whether the application received a favorable lender decision |
| Applicant Gender | Applicant gender category used in the HMDA record |
| Applicant Race | Applicant race category used in the HMDA record |
| Race-Gender Group | Combined race and gender segment used for subgroup comparison |
| Property Type | Property category, including 1-4 unit dwelling, manufactured housing, or multifamily |
| Income Group | Grouped applicant income category used to make income comparisons easier to interpret |
| Income Relative to Area | Income or income-context measure used to compare applicant or area income levels across geographies |

## Important Notes

- Approval status is a simplified analytical field created for dashboard comparison.
- Race-gender groups are used for descriptive subgroup analysis only.
- Income groups are ranges created to make income comparisons easier to visualize.
- Some HMDA fields describe census tract or area context rather than the individual applicant.
- These fields should not be interpreted as a complete underwriting model.
