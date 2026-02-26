# Gunakan Node.js 20 LTS sebagai base image
FROM node:20-alpine

# Set working directory di dalam container
WORKDIR /app

# Copy package.json dan package-lock.json terlebih dahulu
# (layer caching: dependency tidak perlu re-install jika kode berubah)
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy seluruh source code
COPY . .

# Expose port aplikasi
EXPOSE 3000

# Jalankan aplikasi
CMD ["node", "index.js"]
