#!/bin/bash

# Menyimpan GitHub Personal Access Token ke environment variable
# untuk login ke GitHub Container Registry (ghcr.io)
export CR_PAT=<token-kamu>

# Membuat Docker image dari Dockerfile dengan tag latest
# Format nama: ghcr.io/<username>/<nama-image>:tag
docker build -t ghcr.io/symrizals/karsajobs-ui:latest .

# Menampilkan daftar image yang tersedia di lokal
docker images

# Login ke GitHub Container Registry menggunakan PAT
# --password-stdin membaca token dari stdin untuk keamanan
echo $CR_PAT | docker login ghcr.io -u symrizals --password-stdin

# Mengunggah image ke GitHub Container Registry
docker push ghcr.io/symrizals/karsajobs-ui:latest
