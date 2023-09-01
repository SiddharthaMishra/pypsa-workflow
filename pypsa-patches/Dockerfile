FROM continuumio/miniconda3:23.3.1-0

RUN apt clean && apt update
RUN apt install -y zip git curl build-essential default-jre wget

RUN conda install -c conda-forge mamba
COPY ./envs/environment.yaml .
RUN mamba env create --file environment.yaml -n pypsa-earth
RUN conda run -n pypsa-earth pip install google-cloud-storage
WORKDIR /pypsa-earth
RUN conda remove mamba && apt remove -y git gcc build-essential
COPY . .
RUN chmod +x run.sh
CMD ["./run.sh"]

