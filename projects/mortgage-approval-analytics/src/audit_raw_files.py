from pathlib import Path
import csv


# Find the main project folder.
# This works because this script is stored inside the src folder.
PROJECT_ROOT = Path(__file__).resolve().parents[1]

RAW_DATA_DIR = PROJECT_ROOT / "data" / "raw"
AUDIT_OUTPUT_DIR = PROJECT_ROOT / "outputs" / "audit"

# These are the four files we expect to find.
EXPECTED_FILES = {
    "California": "hmda_2017_ca.csv",
    "Illinois": "hmda_2017_il.csv",
    "Michigan": "hmda_2017_mi.csv",
    "Texas": "hmda_2017_tx.csv",
}


def create_file_inventory() -> None:
    """Confirm the raw files exist and record their sizes."""

    AUDIT_OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    inventory = []

    print("Checking raw HMDA files...\n")

    for state, filename in EXPECTED_FILES.items():
        file_path = RAW_DATA_DIR / filename
        file_exists = file_path.is_file()

        if file_exists:
            size_bytes = file_path.stat().st_size
            size_gb = size_bytes / (1024 ** 3)

            print(f"{state}: found — {size_gb:.2f} GB")
        else:
            size_bytes = None
            size_gb = None

            print(f"{state}: FILE NOT FOUND")

        inventory.append(
            {
                "state": state,
                "filename": filename,
                "file_exists": file_exists,
                "size_bytes": size_bytes,
                "size_gb": round(size_gb, 3) if size_gb is not None else None,
            }
        )

    output_path = AUDIT_OUTPUT_DIR / "raw_file_inventory.csv"

    with output_path.open("w", newline="", encoding="utf-8") as output_file:
        writer = csv.DictWriter(
            output_file,
            fieldnames=[
                "state",
                "filename",
                "file_exists",
                "size_bytes",
                "size_gb",
            ],
        )

        writer.writeheader()
        writer.writerows(inventory)

    missing_files = [
        row["filename"] for row in inventory if not row["file_exists"]
    ]

    if missing_files:
        raise FileNotFoundError(
            "The following expected files were not found: "
            + ", ".join(missing_files)
        )

    print(f"\nInventory saved to: {output_path}")


if __name__ == "__main__":
    create_file_inventory()