# Use the CUDA development base image
FROM nvidia/cuda:12.2.0-devel-ubuntu20.04

# Set non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    openssh-server \
    nfs-common \
    git \
    curl \
    wget \
    software-properties-common \
    build-essential \
    unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Python 3.12
RUN add-apt-repository ppa:deadsnakes/ppa -y && apt-get update && apt-get install -y \
    python3.12 \
    python3.12-venv \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install pip and essential Python tools
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.12 && \
    pip install --upgrade pip setuptools wheel

# Set Python 3.12 as default
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.12 1

# Install essential Python packages
RUN pip install \
    tensorflow \
    jax[cpu] \
    ipykernel \
    six==1.17.0 \
    ipykernel

# Configure SSH
RUN mkdir /var/run/sshd && echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config && \
    echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

# Expose SSH port
EXPOSE 22

# Start SSH service
CMD service ssh start && bash
