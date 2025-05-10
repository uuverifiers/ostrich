# The Artifact of OSTRICH2
This repository contains the Docker image for the artifact of OSTRICH2, an efficient SMT solver for the string theory.
The artifact is only test for Linux and WSL2 in Windows now. You need about (77/the number of CPU cores) hours to run the experiments.   

# Requirements
- A Docker [installation](https://docs.docker.com/engine/install/)
- 8 GB of RAM
- 3 GB of disk space for the Docker image
- 2 CPU cores (or more), the more the less time it takes to run the experiments


# Building the Docker image
To build the Docker image, run the following command in the root folder of the repository:

```bash
sudo docker build -t ostrich2-artifact .
```

If you want to reinstall all solvers and dependencies before building the image, run:

```bash
sudo docker build --build-arg REINSTALL=true -t ostrich2-artifact .
```
This will remove all solver binaries previously installed in the image and reinstall them.

# Running the Docker image
To run the Docker image, use the following command:

```bash
sudo docker run -it --rm --name ostrich2-artifact ostrich2-artifact
```
This will start a new container named `ostrich2-artifact` and open an interactive terminal session inside it. The experiment are run automatically when the container starts.


# Web Interface

For experiments, OSTRICH2 can also be used through its [web interface.](https://eldarica.org/ostrich/)
