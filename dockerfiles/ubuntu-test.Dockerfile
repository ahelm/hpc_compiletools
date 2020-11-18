FROM ubuntu

RUN groupadd -r hpc_user && useradd -r -g hpc_user hpc_user
USER hpc_user

WORKDIR /project