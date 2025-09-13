FROM ubuntu:24.04

# Avoid prompts from apt-get
ARG DEBIAN_FRONTEND=noninteractive
ARG NTHREADS=18

RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:ubuntu-toolchain-r/test -y && apt-get update
RUN apt-get install -y cmake libtool autoconf libboost-filesystem-dev \
    libboost-iostreams-dev libboost-serialization-dev libboost-thread-dev \
    libboost-test-dev libssl-dev libjsoncpp-dev libcurl4-openssl-dev \
    libjsoncpp-dev libjsonrpccpp-dev libsnappy-dev zlib1g-dev libbz2-dev \
    liblz4-dev libzstd-dev libjemalloc-dev libsparsehash-dev python3-dev \
    python3-pip pkg-config git g++ gcc ffmpeg libcairo2 libcairo2-dev curl \
    libgflags-dev


ADD . /blocksci


# RUN curl -LsSf https://astral.sh/uv/install.sh | sh
# RUN /root/.local/bin/uv python install 3.8.20
# RUN /root/.local/bin/uv python pin 3.8.20

ADD https://astral.sh/uv/install.sh /uv-installer.sh
RUN sh /uv-installer.sh && rm /uv-installer.sh
ENV PATH="/root/.local/bin/:$PATH"

# RUN /root/.local/bin/uv run which pip3

RUN mkdir -p /usr/lib/python3.8/site-packages/

# RUN cd /blocksci && \
#     uv venv && CC=gcc CXX=g++ uv pip install -r /blocksci/pip-all-requirements.txt

# Build BlockSci
RUN cd blocksci && \
    rm -rf build && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make -j${NTHREADS} && \
    make install

# Install BlockSci Python bindings

RUN cd blocksci && rm -rf blockscipy/build && \
    uv venv && CC=gcc CXX=g++ uv run pip3 install -e blockscipy

# remove the build folder for blockscipy, as we will rebuild again anyway

RUN rm -rf /blocksci/blockscipy/build

# Set the default command for the container
CMD ["/bin/bash"]
