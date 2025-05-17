# Anchor Docker Builder

This repository provides a Docker image to build and run Anchor projects without needing to install Anchor, rust , cargo, solana and its dependencies locally.

---

## Build the Docker Image

### Builds a Docker image from the Dockerfile in the current directory with the container name mentioned in yaml. 
```bash
sudo docker compose build # Run only once after clone
```
# Runs a new container from the image you built and mounts your local directory into /project inside the container, so changes are shared between host and container. -it makes it interactive so you can use terminal commands inside.
```bash
sudo docker compose run anchor-dev
```
# Inside container you can easily edit your code and run multiple times below command with reflecting changes
```bash
root@c46082094160:/project# anchor build
```