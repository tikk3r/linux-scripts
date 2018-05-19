## General linux install.
dnf install htop
dnf install lm_sensors
dnf install texlive*
dnf install vim

## Python specific.
wget https://repo.anaconda.com/archive/Anaconda2-5.1.0-Linux-x86_64.sh
bash Anaconda2-5.1.0-Linux-x86_64.sh
conda install -c conda-forge jupyterlab

## LOFAR specific.
# Virtual machine tools.
dnf install -y qemu-kvm virt-manager virt-install
# CentOS 7 minimal image.
wget http://mirror.widexs.nl/ftp/pub/os/Linux/distr/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1804.iso -P ~/Downloads
