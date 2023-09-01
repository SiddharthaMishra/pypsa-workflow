import json

rule upload_prepared_network:
    input:
        "networks/" + RDIR + "elec_s{simpl}_{clusters}_ec_l{ll}_{opts}.nc",
    output:
        touch("networks/" + RDIR + "elec_s{simpl}_{clusters}_ec_l{ll}_{opts}.uploaded.done")
    shell:
        "python workflow-helpers/upload-file.py {input} prepared-networks"


rule upload_all_prepared_networks:
    input:
        expand(
             "networks/" + RDIR + "elec_s{simpl}_{clusters}_ec_l{ll}_{opts}.uploaded.done",
             **config["scenario"]
        ),
    run:
        with open("/tmp/all_networks.txt", "w") as f:
            json.dump([i.split("/")[-1].replace(".uploaded.done", "") for i in input], f)
        
