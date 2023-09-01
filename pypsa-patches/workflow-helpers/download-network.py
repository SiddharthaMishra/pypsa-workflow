import os
from google.cloud import storage

def main():
    project_id = os.environ.get("PROJECT_ID", "crucial-oven-386720")
    storage_client = storage.Client(project=project_id)
    bucket = storage_client.bucket(os.environ.get("BUCKET_NAME", "payment-dashboard"))

    bucket.blob(f"{os.environ['RUN_FOLDER_PATH']}/prepared-networks/{os.environ['PREPARED_NETWORK_OPTS']}.nc").download_to_filename(f"networks/{os.environ['PREPARED_NETWORK_OPTS']}.nc")
    print(f"downloaded {os.environ['PREPARED_NETWORK_OPTS']}.nc to networks/")

if __name__ == "__main__":
    main()
