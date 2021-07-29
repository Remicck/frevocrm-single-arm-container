# F-RevoCRM Single Container for ARM CPU
This repository is used for QNAP NAS Server working on arm cpu.

## Defference from Docker of F-RevoCRM Github Repository
- Single Container
  - Not using docker compose
  - Docker Hub avaiables

## Usage
```sh
docker build ./ -t frevocrm-single-arm
docker run -d -it --name fr2 -p 8000:80 --env-file .env frevocrm-single-arm:latest
```
