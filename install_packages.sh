#!/bin/bash
apt-get -y update
apt-get -y dist-upgrade

# Установка пакетов Ubuntu
PACKAGES="build-essential python3.5 python3.5-dev python3-pip python3-tk net-tools"
apt-get -y install $PACKAGES

# Установка пакетов Python3
yes | pip3 install --upgrade pip
yes | pip3 install decorator flask==1.0.2 flask-httpauth==3.2.4 gevent==1.3.7 h5py keras numpy pillow requests

# Установка tensorflow
if [[ $1 = 'gpu' ]]
then 
    yes | pip3 install tensorflow-gpu==1.7.0
    # install CUDA Toolkit v9.0
    # instructions from https://developer.nvidia.com/cuda-downloads (linux -> x86_64 -> Ubuntu -> 16.04 -> deb)
    CUDA_REPO_PKG="cuda-repo-ubuntu1604-9-0-local_9.0.176-1_amd64-deb"
    wget https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/${CUDA_REPO_PKG}
    sudo dpkg -i ${CUDA_REPO_PKG}
    sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
    sudo apt-get update
    sudo apt-get -y install cuda-9-0
    
    CUDA_PATCH1="cuda-repo-ubuntu1604-9-0-local-cublas-performance-update_1.0-1_amd64-deb"
    wget https://developer.nvidia.com/compute/cuda/9.0/Prod/patches/1/${CUDA_PATCH1}
    sudo dpkg -i ${CUDA_PATCH1}
    sudo apt-get update
    
    # install cuDNN v7.0
    CUDNN_PKG="libcudnn7_7.0.5.15-1+cuda9.0_amd64.deb"
    wget https://github.com/ashokpant/cudnn_archive/raw/master/v7.0/${CUDNN_PKG}
    sudo dpkg -i ${CUDNN_PKG}
    sudo apt-get update
    
    # install NVIDIA CUDA Profile Tools Interface (libcupti-dev v9.0)
    sudo apt-get install cuda-command-line-tools-9-0
    
    # set environment variables
    export PATH=${PATH}:/usr/local/cuda-9.0/bin
    export CUDA_HOME=${CUDA_HOME}:/usr/local/cuda:/usr/local/cuda-9.0
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/cuda-9.0/lib64
else 
    yes | pip3 install tensorflow==1.7.0
fi

# Очистка кеша
apt-get -y autoremove
apt-get -y autoclean
apt-get -y clean


