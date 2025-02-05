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


def generate_model_yml(layer, subfolder, prefix, model_name=None):
    # Set up logging
    setup_logging()

    # Get the absolute path of the script's directory
    script_dir = os.path.dirname(os.path.abspath(__file__))

    # Paths relative to the project root
    models_path = os.path.join(script_dir, "..", "models", layer, subfolder)
    seeds_path = os.path.join(script_dir, "..", "seeds", layer)

    # Ensure paths exist
    if not os.path.exists(models_path):
        logging.error(f"Models path '{models_path}' does not exist.")
        raise FileNotFoundError(f"Models path '{models_path}' does not exist.")
    if not os.path.exists(seeds_path):
        logging.error(f"Seeds path '{seeds_path}' does not exist.")
        raise FileNotFoundError(f"Seeds path '{seeds_path}' does not exist.")

    # Filter seed files based on model_name if specified
    all_seed_files = os.listdir(seeds_path)

    
    if model_name:
        seed_files = [f for f in all_seed_files if f"__{model_name}__" in f]
    else:
        seed_files = all_seed_files  # Process all seed files if no model_name is specified

    if not seed_files:
        logging.warning(f"No seed files found in '{seeds_path}' matching the criteria.")
        return

    for seed_file in seed_files:
        # Extract {source} and {model_name} from the seed file name
        parts = seed_file.split("__")
        if len(parts) < 3:
            logging.warning(f"Skipping file '{seed_file}' due to unexpected naming format.")
            continue

        source = parts[0].replace("seed_", "")  # Extract the source
        extracted_model_name = parts[1]  # Extract model_name

        # Ensure we only process the matching source folder
        source_folder_path = os.path.join(models_path)
        print(source_folder_path)
        if not os.path.exists(source_folder_path):
            logging.warning(f"Skipping '{seed_file}': No corresponding model folder for source '{source}'.")
            continue

        logging.info(f"Processing model: {prefix}_{source}__{extracted_model_name}")

        seed_file_path = os.path.join(seeds_path, seed_file)

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

        # Generate YAML structure
        models = [{
            "name": f"{prefix}_{source}__{extracted_model_name}",
            "columns": columns,
        }]

        # Generate YAML file in the correct source subfolder
        yml_path = os.path.join(source_folder_path, f"{source}__models.yml")
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
    parser.add_argument("layer", help="Subfolder under models/.")
    parser.add_argument("subfolder", help="Subfolder under models/layer and seeds/.")
    parser.add_argument("prefix", help="Model prefix (e.g., stg).")
    parser.add_argument("--model_name", "-m", help="Specific model name to generate YAML for", default=None)

    args = parser.parse_args()

    try:
        generate_model_yml(args.layer, args.subfolder, args.prefix, args.model_name)
    except Exception as e:
        logging.error(f"Script failed: {e}")
