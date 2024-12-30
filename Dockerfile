FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
# Set Node.js environment variable to fix OpenSSL error
ENV NODE_OPTIONS="--openssl-legacy-provider"
RUN npm run build
EXPOSE 3000
CMD ["npm", "start"]
