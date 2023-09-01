import os
from google.cloud import storage
import yaml

def main():
    project_id = os.environ.get("PROJECT_ID", "crucial-oven-386720")
    storage_client = storage.Client(project=project_id)
    bucket = storage_client.bucket(os.environ.get("BUCKET_NAME", "payment-dashboard"))

    if os.getenv("IS_TEST_RUN", None) != "true":
        bucket.blob(os.environ["RUN_FOLDER_PATH"] + "/configs/config.yaml").download_to_filename("config.yaml")
    bucket.blob(os.environ["RUN_FOLDER_PATH"] + "/configs/bundle_config.yaml").download_to_filename("configs/bundle_config.yaml")
    bucket.blob(os.environ["RUN_FOLDER_PATH"] + "/configs/powerplantmatching_config.yaml").download_to_filename("configs/powerplantmatching_config.yaml")

    with open("config.yaml", "r") as f:
        config = yaml.load(f, Loader=yaml.Loader)
    config["custom_rules"] = ['./workflow-rules/workflow.smk']
    with open("config.yaml", "w") as f:
        print(config)
        yaml.dump(config, f, default_flow_style=False)
if __name__ == "__main__":
    main()
