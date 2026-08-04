--Overall mortgage decision summary
SELECT
    COUNT(*) AS total_applications,
    SUM(favorable_decision) AS favorable_decisions,
    COUNT(*) - SUM(favorable_decision) AS denied_applications,
    ROUND(100.0 * AVG(favorable_decision), 2) AS favorable_decision_rate
FROM hmda_analysis;

--Favorable-decision rate by state
SELECT
    state_name,
    COUNT(*) AS total_applications,
    CAST(SUM(favorable_decision) AS BIGINT)
        AS favorable_decisions,
    COUNT(*) - CAST(SUM(favorable_decision) AS BIGINT)
        AS denied_applications,
    ROUND(
        100.0 * AVG(favorable_decision), 2) AS favorable_decision_rate
FROM hmda_analysis
GROUP BY state_name
ORDER BY favorable_decision_rate DESC;

--Favorable-decision rate by property type
SELECT
    property_type,
    COUNT(*) AS total_applications,
    CAST(SUM(favorable_decision) AS BIGINT)
        AS favorable_decisions,
    COUNT(*) - CAST(SUM(favorable_decision) AS BIGINT)
        AS denied_applications,
    ROUND(100.0 * AVG(favorable_decision), 2) AS favorable_decision_rate,
    CAST(MEDIAN(loan_amount) AS BIGINT)
        AS median_loan_amount
FROM hmda_analysis
GROUP BY property_type
ORDER BY favorable_decision_rate DESC;

--Favorable-decision rate by state and property type
SELECT
    state_name,
    property_type,
    COUNT(*) AS total_applications,
    CAST(SUM(favorable_decision) AS BIGINT)
        AS favorable_decisions,
    COUNT(*) - CAST(SUM(favorable_decision) AS BIGINT)
        AS denied_applications,
    ROUND(100.0 * AVG(favorable_decision), 2) AS favorable_decision_rate,
    CAST(MEDIAN(loan_amount) AS BIGINT)
        AS median_loan_amount
FROM hmda_analysis
GROUP BY
    state_name,
    property_type
ORDER BY
    property_type,
    favorable_decision_rate DESC;

-- Reported denial reasons by property type
WITH denial_counts AS (
    SELECT
        property_type,
        COALESCE(
            primary_denial_reason,
            'Reason Not Reported'
        ) AS denial_reason,
        COUNT(*) AS denied_applications
    FROM hmda_analysis
    WHERE favorable_decision = 0
    GROUP BY
        property_type,
        denial_reason
)
SELECT
    property_type,
    denial_reason,
    denied_applications,
    ROUND(100.0 * denied_applications / SUM(denied_applications) OVER (PARTITION BY property_type),2)
    AS percent_of_property_denials
FROM denial_counts
ORDER BY
    property_type,
    denied_applications DESC;

-- Favorable-decision rate by loan purpose
SELECT
    loan_purpose,
    COUNT(*) AS total_applications,
    CAST(SUM(favorable_decision) AS BIGINT)
        AS favorable_decisions,
    COUNT(*) - CAST(SUM(favorable_decision) AS BIGINT)
        AS denied_applications,
    ROUND(100.0 * AVG(favorable_decision), 2) AS favorable_decision_rate,
    CAST(MEDIAN(loan_amount) AS BIGINT)
        AS median_loan_amount
FROM hmda_analysis
GROUP BY loan_purpose
ORDER BY favorable_decision_rate DESC;

-- Favorable-decision rate by loan type
SELECT
    loan_type,
    COUNT(*) AS total_applications,
    CAST(SUM(favorable_decision) AS BIGINT)
        AS favorable_decisions,
    COUNT(*) - CAST(SUM(favorable_decision) AS BIGINT)
        AS denied_applications,
    ROUND(100.0 * AVG(favorable_decision), 2) AS favorable_decision_rate,
    CAST(MEDIAN(loan_amount) AS BIGINT)
        AS median_loan_amount
FROM hmda_analysis
GROUP BY loan_type
ORDER BY favorable_decision_rate DESC;

-- Favorable-decision rate by owner-occupancy status
SELECT
    owner_occupancy,
    COUNT(*) AS total_applications,
    CAST(SUM(favorable_decision) AS BIGINT)
        AS favorable_decisions,
    COUNT(*) - CAST(SUM(favorable_decision) AS BIGINT)
        AS denied_applications,
    ROUND(100.0 * AVG(favorable_decision), 2) AS favorable_decision_rate,
    CAST(MEDIAN(loan_amount) AS BIGINT)
        AS median_loan_amount
FROM hmda_analysis
GROUP BY owner_occupancy
ORDER BY favorable_decision_rate DESC;

--Favorable-decision rate by reported applicant race
--Records marked Not Reported or Not Applicable are excluded
--only from this demographic comparison
SELECT
    applicant_race,
    COUNT(*) AS total_applications,
    CAST(SUM(favorable_decision) AS BIGINT)
        AS favorable_decisions,
    COUNT(*) - CAST(SUM(favorable_decision) AS BIGINT)
        AS denied_applications,
    ROUND(100.0 * AVG(favorable_decision), 2) AS favorable_decision_rate,
    CAST(MEDIAN(loan_amount) AS BIGINT)
        AS median_loan_amount,
    CAST(MEDIAN(applicant_income) AS BIGINT)
        AS median_applicant_income
FROM hmda_analysis
WHERE applicant_race NOT IN (
    'Not Reported',
    'Not Applicable'
)
GROUP BY applicant_race
ORDER BY favorable_decision_rate DESC;

--Favorable-decision rate by reported applicant sex
--Records marked Not Reported or Not Applicable are excluded
--only from this demographic comparison
SELECT
    applicant_sex,
    COUNT(*) AS total_applications,
    CAST(SUM(favorable_decision) AS BIGINT)
        AS favorable_decisions,
    COUNT(*) - CAST(SUM(favorable_decision) AS BIGINT)
        AS denied_applications,
    ROUND(100.0 * AVG(favorable_decision), 2) AS favorable_decision_rate,
    CAST(MEDIAN(loan_amount) AS BIGINT)
        AS median_loan_amount,
    CAST(MEDIAN(applicant_income) AS BIGINT)
        AS median_applicant_income
FROM hmda_analysis
WHERE applicant_sex NOT IN (
    'Not Reported',
    'Not Applicable'
)
GROUP BY applicant_sex
ORDER BY favorable_decision_rate DESC;

--Favorable-decision rate by reported applicant ethnicity
--Records marked Not Reported or Not Applicable are excluded
--only from this demographic comparison
SELECT
    applicant_ethnicity,
    COUNT(*) AS total_applications,
    CAST(SUM(favorable_decision) AS BIGINT)
        AS favorable_decisions,
    COUNT(*) - CAST(SUM(favorable_decision) AS BIGINT)
        AS denied_applications,
    ROUND(100.0 * AVG(favorable_decision), 2) AS favorable_decision_rate,
    CAST(MEDIAN(loan_amount) AS BIGINT)
        AS median_loan_amount,
    CAST(MEDIAN(applicant_income) AS BIGINT)
        AS median_applicant_income
FROM hmda_analysis
WHERE applicant_ethnicity NOT IN (
    'Not Reported',
    'Not Applicable'
)
GROUP BY applicant_ethnicity
ORDER BY favorable_decision_rate DESC;

--Favorable-decision rate by reported race and sex
--Records with unreported or non-applicable demographics are excluded
--only from this comparison
SELECT
    applicant_race,
    applicant_sex,
    COUNT(*) AS total_applications,
    CAST(SUM(favorable_decision) AS BIGINT)
        AS favorable_decisions,
    COUNT(*) - CAST(SUM(favorable_decision) AS BIGINT)
        AS denied_applications,
    ROUND(100.0 * AVG(favorable_decision), 2) AS favorable_decision_rate,
    CAST(MEDIAN(loan_amount) AS BIGINT)
        AS median_loan_amount,
    CAST(MEDIAN(applicant_income) AS BIGINT)
        AS median_applicant_income
FROM hmda_analysis
WHERE applicant_race NOT IN (
    'Not Reported',
    'Not Applicable'
)
AND applicant_sex NOT IN (
    'Not Reported',
    'Not Applicable'
)
GROUP BY
    applicant_race,
    applicant_sex
ORDER BY favorable_decision_rate DESC;

--Distribution of reported applicant income
--Missing income records are excluded from this calculation
SELECT
    COUNT(*) AS applications_with_reported_income,
    CAST(MIN(applicant_income) AS BIGINT)
        AS minimum_income,
    CAST(QUANTILE_CONT(applicant_income, 0.25) AS BIGINT)
        AS income_25th_percentile,
    CAST(MEDIAN(applicant_income) AS BIGINT)
        AS median_income,
    CAST(QUANTILE_CONT(applicant_income, 0.75) AS BIGINT)
        AS income_75th_percentile,
    CAST(QUANTILE_CONT(applicant_income, 0.90) AS BIGINT)
        AS income_90th_percentile,
    CAST(QUANTILE_CONT(applicant_income, 0.99) AS BIGINT)
        AS income_99th_percentile,
    CAST(MAX(applicant_income) AS BIGINT)
        AS maximum_income
FROM hmda_analysis
WHERE applicant_income IS NOT NULL;

-- Favorable-decision rate by reported applicant-income quartile
WITH income_groups AS (
    SELECT
        favorable_decision,
        loan_amount,
        CASE
            WHEN applicant_income IS NULL
                THEN 'Not Reported'
            WHEN applicant_income <= 58000
                THEN '$58,000 or Less'
            WHEN applicant_income <= 90000
                THEN '$58,001-$90,000'
            WHEN applicant_income <= 140000
                THEN '$90,001-$140,000'
            ELSE 'Above $140,000'
        END AS applicant_income_band,
        CASE
            WHEN applicant_income IS NULL THEN 5
            WHEN applicant_income <= 58000 THEN 1
            WHEN applicant_income <= 90000 THEN 2
            WHEN applicant_income <= 140000 THEN 3
            ELSE 4
        END AS income_band_order
    FROM hmda_analysis
)
SELECT
    applicant_income_band,
    COUNT(*) AS total_applications,
    CAST(SUM(favorable_decision) AS BIGINT)
        AS favorable_decisions,
    COUNT(*) - CAST(SUM(favorable_decision) AS BIGINT)
        AS denied_applications,
    ROUND(100.0 * AVG(favorable_decision), 2) AS favorable_decision_rate,
    CAST(MEDIAN(loan_amount) AS BIGINT)
        AS median_loan_amount
FROM income_groups
GROUP BY
    applicant_income_band,
    income_band_order
ORDER BY income_band_order;

--Favorable-decision rate by property type and applicant-income band
--Not Reported is retained because all multifamily applications
--lack reported applicant income
SELECT
    property_type,
    applicant_income_band,
    income_band_order,
    COUNT(*) AS total_applications,
    CAST(SUM(favorable_decision) AS BIGINT)
        AS favorable_decisions,
    COUNT(*) - CAST(SUM(favorable_decision) AS BIGINT)
        AS denied_applications,
    ROUND(100.0 * AVG(favorable_decision), 2) AS favorable_decision_rate,
    CAST(MEDIAN(loan_amount) AS BIGINT)
        AS median_loan_amount
FROM hmda_analysis
GROUP BY
    property_type,
    applicant_income_band,
    income_band_order
ORDER BY
    property_type,
    income_band_order;