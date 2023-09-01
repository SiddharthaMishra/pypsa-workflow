#!/usr/bin/env bash
if [ ! -z $PYPSA_BUILDER_TAG ]; then
    PYPSA_BUILDER_TAG="main"
fi

git checkout $PYPSA_BUILDER_TAG

if [ ! -z $PYPSA_IMAGE_PATH ]; then
    PYPSA_IMAGE_PATH="europe-central2-docker.pkg.dev/crucial-oven-386720/pypsa-workflow/pypsa"
fi

# check what the last change to pypsa-patches was, we build images for each (pypsa-earth-commit, pypsa-patches-commit) pair. So if pypsa pathches hasn't 
# changed and we've build the pypsa-earth image for the specific commit already, we don't need to rebuild it

last_pypsa_patch=$(git log -n 1 --pretty=format:%H -- pypsa-patches)
pypsa_builder_hash=$(git rev-parse --short $last_pypsa_patch)
git clone --branch main https://github.com/pypsa-meets-earth/pypsa-earth.git

cd pypsa-earth

if [ ! -z "$PYPSA_TAG" ]; then
    PYPSA_TAG="main"
fi
git checkout $PYPSA_TAG

PYPSA_COMMIT_HASH=$(git rev-parse --short HEAD)
export pypsa_reg_tag=$PYPSA_COMMIT_HASH-$pypsa_builder_hash
echo $PYPSA_IMAGE_PATH:$pypsa_reg_tag > /tmp/image.txt


# check if the image for the (pypsa-earth-commit, pypsa-patches-commit) pair already exists
existing_tags=$(gcloud container images list-tags --filter="tags:$pypsa_reg_tag" --format=json $PYPSA_IMAGE_PATH)

if [[ "$existing_tags" == "[]" ]]; then
  echo "tag does not exist"
else
  echo "tag exists"
  exit 0
fi

cp -r ../pypsa-patches/* .

# If the tag doesn't exist, create the new image using google cloud build

rm config.default.yaml config.tutorial.yaml
gcloud config set gcloudignore/enabled false
gcloud builds submit --config build-config.yaml --region europe-west1 --substitutions="_IMAGE_PATH=$PYPSA_IMAGE_PATH","_IMAGE_TAG=$pypsa_reg_tag"

