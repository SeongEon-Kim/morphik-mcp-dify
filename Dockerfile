FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Copy source code
COPY . .

# Install dependencies and build in one step
RUN npm install && \
    npm run build:streamable && \
    npm ci --omit=dev

# Expose port (Railway uses PORT env var)
EXPOSE 8976

# Note: Railway handles health checks via the /health endpoint

# Start the HTTP server
CMD ["node", "build/index_http.js"]