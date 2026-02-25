#!/bin/bash

# Menyimpan password Docker Hub ke environment variable
export PASSWORD_DOCKER_HUB=jr7fsPFcptcX3Me

# 1. Membuat Docker image dari Dockerfile dengan nama karsajobs-ui
docker build -t karsajobs-ui:latest .

# 2. Melihat daftar image di lokal
docker images

# 3. Mengubah nama image agar sesuai dengan format Docker Hub
docker tag karsajobs-ui:latest symrizals/karsajobs-ui:latest

# 4. Login ke Docker Hub menggunakan environment variable
echo $PASSWORD_DOCKER_HUB | docker login -u symrizals --password-stdin

# 5. Mengunggah image ke Docker Hub
docker push symrizals/karsajobs-ui:latest