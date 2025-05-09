# The Artifact of OSTRICH2
OSTRICH2 is an SMT solver for string constraints. And this repository contains the Docker image for the OSTRICH2 artifact.

# Requirements
- A Docker [installation](https://docs.docker.com/engine/install/)


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

# Using OSTRICH2
After installing [the Scala Build tool (SBT)](https://www.scala-sbt.org/), you can assemble a JAR file using `sbt assembly`. To run it, use either the `ostrich` script in the root folder, or `ostrich-client`. The latter transparently spins up a server that continuously serves requests from the client script; useful to avoid cold-starting the JVM if you are running many instances.

See `./ostrich -help` for more options.

# Web Interface

For experiments, OSTRICH2 can also be used through its [web interface.](https://eldarica.org/ostrich/)
