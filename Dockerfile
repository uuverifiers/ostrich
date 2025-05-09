FROM python:3.11-slim

# Argument used to control if reinstall before build
ARG REINSTALL=false

ENV WORKD_DIR=/opt
ENV BINARY_DIR=$WORKD_DIR/zaligvinder/SolverBinaries

WORKDIR $WORKD_DIR

# Install basic dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    graphviz \
    git \
    wget \
    unzip \
    curl \
    ca-certificates \
    apt-transport-https \
    gnupg \
    build-essential \
    cmake \
    libgmp-dev \
    bc \
    dos2unix \
    && rm -rf /var/lib/apt/lists/*

RUN pip install numpy tabulate npyscreen matplotlib

# Install Java
RUN apt-get update && apt-get install -y --no-install-recommends \
    default-jdk \
    && rm -rf /var/lib/apt/lists/*

# Add scala repository and install scala + sbt (using the correct method)
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | tee /etc/apt/sources.list.d/sbt.list && \
    echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | tee /etc/apt/sources.list.d/sbt_old.list && \
    curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | tee /etc/apt/trusted.gpg.d/sbt.asc && \
    apt-get update && \
    apt-get install -y --no-install-recommends sbt scala && \
    rm -rf /var/lib/apt/lists/*

# Copy source code and zaligvinder files
COPY . .

# Copy all scripts to the scripts directory
COPY scripts/* $WORKD_DIR/scripts/

# Ensure all scripts are executable
RUN chmod +x /opt/scripts/*.sh && \
    find /opt/scripts -name "*.sh" -exec dos2unix {} \;

# Reinstall all solvers if needed
RUN if [ "$REINSTALL" = true ]; then \
        echo "Reinstalling all solvers..."; \
        bash $WORKD_DIR/scripts/reinstall_solvers.sh; \
    else \
        echo "Skipping solver reinstallation..."; \
    fi

# Create a entrypoint script
RUN echo '#!/bin/bash\n\
./zaligvinder/importToolPath.sh\n\
python zaligvinder/fmcad.py' > $WORKD_DIR/entrypoint.sh && \
    chmod +x $WORKD_DIR/entrypoint.sh

# Set the entrypoint
ENV ENTRY_SCRIPT=$WORKD_DIR/entrypoint.sh
ENTRYPOINT ["/bin/bash", "-c", "$ENTRY_SCRIPT"]


