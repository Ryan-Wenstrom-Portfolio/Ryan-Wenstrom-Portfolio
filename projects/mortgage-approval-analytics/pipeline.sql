--Build a smaller working table from the four raw HMDA files
CREATE OR REPLACE TABLE hmda_analysis AS

SELECT
    --Fields used to identify and validate records
    as_of_year,
    respondent_id,
    agency_code,
    sequence_number,

    --Loan characteristics
    CASE loan_type_name
        WHEN 'FHA-insured' THEN 'FHA'
        WHEN 'VA-guaranteed' THEN 'VA'
        WHEN 'FSA/RHS-guaranteed' THEN 'FSA/RHS'
        ELSE loan_type_name
    END AS loan_type,

    CASE property_type_name
        WHEN 'One-to-four family dwelling (other than manufactured housing)'
            THEN '1-4 Unit Dwelling'
        WHEN 'Manufactured housing'
            THEN 'Manufactured Housing'
        WHEN 'Multifamily dwelling'
            THEN 'Multifamily'
        ELSE property_type_name
    END AS property_type,

    CASE loan_purpose_name
        WHEN 'Home purchase' THEN 'Purchase'
        WHEN 'Refinancing' THEN 'Refinance'
        WHEN 'Home improvement' THEN 'Home Improvement'
        ELSE loan_purpose_name
    END AS loan_purpose,

    CASE owner_occupancy_name
        WHEN 'Owner-occupied as a principal dwelling'
            THEN 'Owner Occupied'
        WHEN 'Not owner-occupied as a principal dwelling'
            THEN 'Not Owner Occupied'
        WHEN 'Not applicable'
            THEN 'Not Applicable'
        ELSE owner_occupancy_name
    END AS owner_occupancy,
    CAST(loan_amount_000s * 1000 AS BIGINT) AS loan_amount,

    --Application outcome
    action_taken,
    action_taken_name,
    CASE
        WHEN action_taken IN (1, 2) THEN 1
        WHEN action_taken = 3 THEN 0
    END AS favorable_decision,

    --Geography
    state_name,
    state_abbr,
    state_code,
    county_name,
    county_code,
    census_tract_number,

    --Applicant characteristics
    CASE applicant_ethnicity_name
        WHEN 'Information not provided by applicant in mail, Internet, or telephone application'
            THEN 'Not Reported'
        WHEN 'Not applicable'
            THEN 'Not Applicable'
        ELSE applicant_ethnicity_name
    END AS applicant_ethnicity,

    CASE applicant_race_name_1
        WHEN 'Information not provided by applicant in mail, Internet, or telephone application'
            THEN 'Not Reported'
        WHEN 'Not applicable'
            THEN 'Not Applicable'
        ELSE applicant_race_name_1
    END AS applicant_race,

    CASE applicant_sex_name
        WHEN 'Information not provided by applicant in mail, Internet, or telephone application'
            THEN 'Not Reported'
        WHEN 'Not applicable'
            THEN 'Not Applicable'
        ELSE applicant_sex_name
    END AS applicant_sex,
    --Adding loan-to-income
    CAST(applicant_income_000s * 1000 AS BIGINT) AS applicant_income,

    -- Income bands based on quartiles of reported applicant income
    CASE
        WHEN applicant_income_000s IS NULL
            THEN 'Not Reported'
        WHEN applicant_income_000s * 1000 <= 58000
            THEN '$58,000 or Less'
        WHEN applicant_income_000s * 1000 <= 90000
            THEN '$58,001-$90,000'
        WHEN applicant_income_000s * 1000 <= 140000
            THEN '$90,001-$140,000'
        ELSE 'Above $140,000'
    END AS applicant_income_band,

    CASE
        WHEN applicant_income_000s IS NULL THEN 5
        WHEN applicant_income_000s * 1000 <= 58000 THEN 1
        WHEN applicant_income_000s * 1000 <= 90000 THEN 2
        WHEN applicant_income_000s * 1000 <= 140000 THEN 3
        ELSE 4
    END AS income_band_order,

    CASE
        WHEN applicant_income_000s > 0
            AND loan_amount_000s IS NOT NULL
        THEN
            CAST(loan_amount_000s AS DOUBLE)
            / applicant_income_000s
    END AS loan_to_income_ratio,

    --Denial information
    denial_reason_name_1 AS primary_denial_reason,

    --Census tract context
    population,
    minority_population AS minority_population_percent,
    hud_median_family_income,
    --Census tract income as a percentage of the MSA median
    tract_to_msamd_income / 100.0
        AS tract_income_ratio_to_msa_median

FROM read_csv_auto(
    '__CSV_PATTERN__',
    header = true,
    union_by_name = true,
    sample_size = 100000
)
WHERE action_taken IN (1, 2, 3);
DROP TABLE IF EXISTS hmda_staging;