## Overview
This repository contains Dockerfiles to build python base containers for PCORnet Query Fullfillment. Each new query will pull from the base image build from this repo and add query specific packages and codes.

## Images

image            | base_image      | description 
---------------- | --------------- | -----------
[qf-python-base](https://hub.docker.com/r/pcornetqf/qf-python-base)   |  ubuntu:jammy  |  Install python3, basic python packages and dependencies to run PCORnet Query Fullfillment


## Quick Start
To get started, ensure you have [Docker installed](https://docs.docker.com/get-docker/). 
### qf-python-base
```
docker run --rm -it pcornetqf/qf-python-base
``` 
This command will build a container with python and pre-installed packages, and start an interactive python session. 
