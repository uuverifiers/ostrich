FROM python:3.11-slim

WORKDIR /opt

# Install basic dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    graphviz \
    git \
    wget \
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

# Install Z3
RUN apt-get update && apt-get install -y --no-install-recommends \
    z3 \
    && rm -rf /var/lib/apt/lists/*

# Install CVC5
RUN wget https://github.com/cvc5/cvc5/releases/download/cvc5-1.0.8/cvc5-Linux -O /usr/local/bin/cvc5 && \
    chmod +x /usr/local/bin/cvc5

# Install Ostrich
RUN git clone https://github.com/uuverifiers/ostrich.git && \
    cd ostrich && \
    git checkout modular_proof_rules && \
    sbt assembly && \
    mkdir -p /usr/local/bin && \
    cp target/scala-*/ostrich-assembly-*.jar /usr/local/bin/ostrich.jar && \
    echo '#!/bin/bash\njava -jar /usr/local/bin/ostrich.jar "$@"' > /usr/local/bin/ostrich && \
    chmod +x /usr/local/bin/ostrich

# Install mata (dependency for z3-noodler)
RUN git clone https://github.com/VeriFIT/mata.git && \
    cd mata && \
    make release && \
    make install

# Install Z3-noodler (with specific commit)
RUN git clone https://github.com/VeriFIT/z3-noodler.git && \
    cd z3-noodler && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make -j$(nproc) && \
    mkdir -p /usr/local/bin/z3-noodler && \
    cp z3 /usr/local/bin/z3-noodler/

# Install Z3-alpha
RUN git clone https://github.com/JohnLyu2/z3alpha.git && \
    mkdir -p /usr/bin/z3alpha && \
    if [ -f "z3alpha/smtcomp24/z3bin/z3" ]; then \
        # Copy if the binary exists at that location
        cp z3alpha/smtcomp24/z3bin/z3 /usr/bin/z3alpha/z3; \
    else \
        # If binary not found, create a symlink to standard z3
        ln -s /usr/bin/z3 /usr/bin/z3alpha/z3; \
    fi


# Copy all scripts to the scripts directory
COPY scripts/* /opt/scripts/


# Ensure all scripts are executable
RUN chmod +x /opt/scripts/*.sh && \
    find /opt/scripts -name "*.sh" -exec dos2unix {} \;

# Set the default command to run the script
# CMD ["./experiment_sat_z3_noodler.sh"]

# Copy source code and models
COPY . .

# Create a flexible cross-platform entrypoint script
RUN echo '#!/bin/sh\n\
# Cross-platform entrypoint script\n\
\n\
# Check if no arguments or "shell" is passed\n\
if [ "$#" -eq 0 ] || [ "$1" = "shell" ]; then\n\
    # Keep container running with interactive shell\n\
    exec /bin/bash\n\
elif [ "$1" = "keep-alive" ]; then\n\
    # Keep container running in background\n\
    tail -f /dev/null\n\
else\n\
    # Check if first argument ends with .sh\n\
    case "$1" in\n\
      *.sh)\n\
        # If the first argument is a shell script, execute it\n\
        exec bash "$@"\n\
        ;;\n\
      *)\n\
        # Otherwise, run the Python command\n\
        exec python3 src/chc.py "$@"\n\
        ;;\n\
    esac\n\
fi' > /opt/entrypoint.sh && \
    chmod +x /opt/entrypoint.sh
VOLUME ["/opt/out"]
ENTRYPOINT ["/opt/entrypoint.sh"]

