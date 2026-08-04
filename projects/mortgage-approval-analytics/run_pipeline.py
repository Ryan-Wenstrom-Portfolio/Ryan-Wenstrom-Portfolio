from pathlib import Path

import duckdb


# The folder containing this Python file is project folder
PROJECT_ROOT = Path(__file__).resolve().parent

RAW_FILE_PATTERN = (
    PROJECT_ROOT / "data" / "raw" / "hmda_2017_*.csv"
)
DATABASE_PATH = PROJECT_ROOT / "data" / "hmda.duckdb"
SQL_PATH = PROJECT_ROOT / "pipeline.sql"

PROCESSED_DIR = PROJECT_ROOT / "data" / "processed"
TABLEAU_PATH = PROCESSED_DIR / "hmda_tableau.csv"

def main() -> None:
    """Build the local HMDA analysis table"""

    csv_pattern = RAW_FILE_PATTERN.as_posix().replace("'", "''")

    PROCESSED_DIR.mkdir(parents=True, exist_ok=True)
    tableau_path = TABLEAU_PATH.as_posix().replace("'", "''")

    # Read the SQL file and insert the CSV location
    sql = SQL_PATH.read_text(encoding="utf-8")
    sql = sql.replace("__CSV_PATTERN__", csv_pattern)

    print("Building HMDA analysis table...")

    connection = duckdb.connect(str(DATABASE_PATH))

    try:
        connection.execute(sql)

        row_count = connection.execute(
            "SELECT COUNT(*) FROM hmda_analysis"
        ).fetchone()[0]     

        column_count = len(
            connection.execute("DESCRIBE hmda_analysis").fetchall()
        )

        state_counts = connection.execute(
            """
            SELECT
                state_abbr,
                COUNT(*) AS row_count
            FROM hmda_analysis
            GROUP BY state_abbr
            ORDER BY state_abbr
            """
        ).fetchall()

        validation = connection.execute(
            """
            SELECT
                SUM(favorable_decision) AS favorable_records,

                COUNT(*) FILTER (
                    WHERE favorable_decision = 0
                ) AS denied_records,

                COUNT(*) FILTER (
                    WHERE loan_amount IS NULL
                ) AS missing_loan_amount,

                COUNT(*) FILTER (
                    WHERE applicant_income IS NULL
                ) AS missing_applicant_income,

                COUNT(*) FILTER (
                    WHERE loan_to_income_ratio IS NULL
                ) AS missing_loan_to_income_ratio

            FROM hmda_analysis
            """
        ).fetchone()

        (
            favorable_records,
            denied_records,
            missing_loan_amount,
            missing_applicant_income,
            missing_loan_to_income_ratio,
        ) = validation

        print("\nExporting Tableau-ready dataset...")

        # Remove the previous export so the pipeline can be rerun
        if TABLEAU_PATH.exists():
            TABLEAU_PATH.unlink()

        connection.execute(
            f"""
            COPY (
                SELECT
                    as_of_year,
                    loan_type,
                    property_type,
                    loan_purpose,
                    owner_occupancy,
                    loan_amount,
                    action_taken_name,
                    favorable_decision,
                    state_name,
                    state_abbr,
                    county_name,
                    county_code,
                    census_tract_number,
                    applicant_ethnicity,
                    applicant_race,
                    applicant_sex,
                    applicant_income,
                    applicant_income_band,
                    income_band_order,
                    loan_to_income_ratio,
                    primary_denial_reason,
                    population,
                    minority_population_percent,
                    hud_median_family_income,
                    tract_income_ratio_to_msa_median
                FROM hmda_analysis
            )
            TO '{tableau_path}'
            (HEADER, DELIMITER ',');
            """
        )

        print(f"Rows: {row_count:,}")
        print(f"Columns: {column_count}")

        print("\nRows by state:")

        for state, count in state_counts:
            print(f"  {state}: {count:,}")

        print("\nValidation summary:")
        print(f"  Favorable decisions:          {favorable_records:,}")
        print(f"  Denied applications:          {denied_records:,}")
        print(f"  Missing loan amount:          {missing_loan_amount:,}")
        print(f"  Missing applicant income:     {missing_applicant_income:,}")
        print(
            f"  Missing loan-to-income ratio: "
            f"{missing_loan_to_income_ratio:,}"
        )
        print(f"\nTableau dataset saved to:\n{TABLEAU_PATH}")

        print("\nPipeline finished successfully")

    finally:
        connection.close()


if __name__ == "__main__":
    main()