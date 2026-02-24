#!/bin/bash

# Menyimpan password Docker Hub ke environment variable
export PASSWORD_DOCKER_HUB=jr7fsPFcptcX3Me

# 1. Membuat Docker image dari Dockerfile dengan nama item-app dan tag v1
docker build -t item-app:v1 .

# 2. Melihat daftar image di lokal
docker images

# 3. Mengubah nama image agar sesuai dengan format Docker Hub
docker tag item-app:v1 symrizals/item-app:v1

# 4. Login ke Docker Hub menggunakan environment variable
echo $PASSWORD_DOCKER_HUB | docker login -u symrizals --password-stdin

# 5. Mengunggah image ke Docker Hub
docker push symrizals/item-app:v1
