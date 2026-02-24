#!/bin/bash

# 1. Build Docker image
docker build -t item-app:v1 .

# 2. Lihat daftar image lokal
docker images

# 3. Tag image sesuai format Docker Hub
docker tag item-app:v1 symrizals/item-app:v1

# 4. Login ke Docker Hub
docker login

# 5. Push image ke Docker Hub
docker push symrizals/item-app:v1
