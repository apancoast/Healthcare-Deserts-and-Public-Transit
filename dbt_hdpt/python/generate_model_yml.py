import os
import csv
import yaml
import logging


def setup_logging():
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s - %(levelname)s - %(message)s",
        handlers=[
            logging.FileHandler("generate_model_yml.log"),
            logging.StreamHandler(),
        ],
    )


class IndentedDumper(yaml.Dumper):
    def increase_indent(self, flow=False, indentless=False):
        return super(IndentedDumper, self).increase_indent(flow, False)


def generate_model_yml(subfolder, prefix):
    # Set up logging
    setup_logging()

    # Get the absolute path of the script's directory
    script_dir = os.path.dirname(os.path.abspath(__file__))

    # Paths relative to the project root
    models_path = os.path.join(script_dir, "..", "models", subfolder)
    seeds_path = os.path.join(script_dir, "..", "seeds", subfolder)

    # Ensure paths exist
    if not os.path.exists(models_path):
        logging.error(f"Models path '{models_path}' does not exist.")
        raise FileNotFoundError(f"Models path '{models_path}' does not exist.")
    if not os.path.exists(seeds_path):
        logging.error(f"Seeds path '{seeds_path}' does not exist.")
        raise FileNotFoundError(f"Seeds path '{seeds_path}' does not exist.")

    # Iterate over subfolders in models/{subfolder}
    for subfolder_2 in os.listdir(models_path):
        subfolder_2_path = os.path.join(models_path, subfolder_2)
        if not os.path.isdir(subfolder_2_path):
            continue

        logging.info(f"Processing subfolder: {subfolder_2}")

        # Find seed files matching the pattern
        seed_files = [
            f
            for f in os.listdir(seeds_path)
            if f.startswith(f"seed_{subfolder_2}__")
            and f.endswith("__data_catalog.csv")
        ]

        # Initialize models list for YAML
        models = []

        for seed_file in seed_files:
            # Extract model_name from seed file name
            parts = seed_file.split("__")
            if len(parts) < 3:
                continue

            model_name = parts[1]
            seed_file_path = os.path.join(seeds_path, seed_file)

            logging.info(f"Processing seed file: {seed_file}")

            # Read CSV to extract stage_column_name and description
            try:
                with open(seed_file_path, "r", encoding="utf-8") as csvfile:
                    reader = csv.DictReader(csvfile)
                    columns = []
                    for row in reader:
                        stage_column_name = row.get("stage_column_name")
                        description = row.get("description")

                        if not stage_column_name or not description:
                            continue
                        
                        cleaned_description = description.strip("\'")
                        columns.append(
                            {
                                "name": stage_column_name,
                                "description": f"{cleaned_description}"
                            }
                        )
                        
            except Exception as e:
                logging.error(f"Error reading file '{seed_file_path}': {e}")
                continue

            # Add model to list
            models.append(
                {
                    "name": f"{prefix}_{subfolder_2}__{model_name}",
                    "columns": columns,
                }
            )

        # Generate YAML file
        yml_path = os.path.join(subfolder_2_path, f"{subfolder_2}__models.yml")
        try:
            with open(yml_path, "w", encoding="utf-8") as ymlfile:
                yaml.dump(
                    {"version": 2, "models": models},
                    ymlfile,
                    Dumper=IndentedDumper,
                    default_flow_style=False,
                    sort_keys=False,
                    width=1000,  # Prevents splitting long lines unnecessarily
                )
            logging.info(f"Generated YAML file: {yml_path}")
        except Exception as e:
            logging.error(f"Error writing YAML file '{yml_path}': {e}")


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Generate dbt model YAML files.")
    parser.add_argument("subfolder", help="Subfolder under models/ and seeds/.")
    parser.add_argument("prefix", help="Model prefix (e.g., stg).")

    args = parser.parse_args()

    try:
        generate_model_yml(args.subfolder, args.prefix)
    except Exception as e:
        logging.error(f"Script failed: {e}")
