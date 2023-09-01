#!/usr/bin/env bash

set -e

if [ -z "$SUBCOMMAND" ]; then
    echo "Please set SUBCOMMAND"
    exit 1
fi

python workflow-helpers/download-configs.py
if [ "$IS_TEST_RUN" = "true" ]; then
    echo found test
    mkdir -p cutouts data resources
    python workflow-helpers/download-test-data.py
fi
if [ "$SUBCOMMAND" = "prepare" ]; then
    snakemake -j $(nproc --all) upload_all_prepared_networks
    rm -rf results *.log *.zip
    zip -r pypsa-data.zip *
    python workflow-helpers/upload-file.py pypsa-data.zip pypsa-data
     
elif [ "$SUBCOMMAND" = "run" ]; then
    python workflow-helpers/download-network.py
    snakemake --allowed-rules solve_network -j $(nproc --all) "results/networks/$PREPARED_NETWORK_OPTS.nc"
    python workflow-helpers/upload-file.py "results/networks/$PREPARED_NETWORK_OPTS.nc" solved-networks
fi
