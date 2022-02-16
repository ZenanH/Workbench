FROM ubuntu:latest

# Julia language environment variables
ENV JULIA_PATH /opt/julia
ENV PATH $JULIA_PATH/bin:$PATH
ENV JULIA_NUM_THREADS 100
# Conda environment variables
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update -q && \
    apt-get install -q -y --no-install-recommends \
        bzip2 \
        ca-certificates \
        git \
        git-lfs \
        libglib2.0-0 \
        libsm6 \
        libxext6 \
        libxrender1 \
        mercurial \
        openssh-client \
        procps \
        subversion \
        wget \
        vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

CMD [ "/bin/bash" ]

ARG CONDA_VERSION=py39_4.10.3

RUN set -x && \
    UNAME_M="$(uname -m)" && \
    if [ "${UNAME_M}" = "x86_64" ]; then \
        MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh"; \
        SHA256SUM="1ea2f885b4dbc3098662845560bc64271eb17085387a70c2ba3f29fff6f8d52f"; \
    elif [ "${UNAME_M}" = "s390x" ]; then \
        MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-s390x.sh"; \
        SHA256SUM="1faed9abecf4a4ddd4e0d8891fc2cdaa3394c51e877af14ad6b9d4aadb4e90d8"; \
    elif [ "${UNAME_M}" = "aarch64" ]; then \
        MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-aarch64.sh"; \
        SHA256SUM="4879820a10718743f945d88ef142c3a4b30dfc8e448d1ca08e019586374b773f"; \
    elif [ "${UNAME_M}" = "ppc64le" ]; then \
        MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-ppc64le.sh"; \
        SHA256SUM="fa92ee4773611f58ed9333f977d32bbb64769292f605d518732183be1f3321fa"; \
    fi && \
    wget "${MINICONDA_URL}" -O miniconda.sh -q && \
    echo "${SHA256SUM} miniconda.sh" > shasum && \
    if [ "${CONDA_VERSION}" != "latest" ]; then sha256sum --check --status shasum; fi && \
    mkdir -p /opt && \
    sh miniconda.sh -b -p /opt/conda && \
    rm miniconda.sh shasum && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy &&\ 
    conda install -c conda-forge jupyterlab; \
    conda install -c conda-forge notebook; \
    conda update --all -y; \
    conda clean --all -y; \
    wget "https://julialang-s3.julialang.org/bin/linux/x64/1.7/julia-1.7.2-linux-x86_64.tar.gz" -O julia.tar.gz; \
    mkdir "$JULIA_PATH"; \
  	tar -xzf julia.tar.gz -C "$JULIA_PATH" --strip-components 1; \
  	rm julia.tar.gz; \
    wget https://raw.githubusercontent.com/ZenanH/Workbench/main/temp.jl -O /opt/julia/etc/julia/startup.jl; \
    wget https://raw.githubusercontent.com/ZenanH/Workbench/main/installation.jl; \
    julia installation.jl; \
    rm installation.jl; \
    rm -f /opt/julia/etc/julia/startup.jl; \
    wget -P /opt/julia/etc/julia https://raw.githubusercontent.com/ZenanH/Workbench/main/startup.jl;