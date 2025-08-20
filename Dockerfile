FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install ALL dependencies first (including dev deps for build)
RUN npm install

# Copy source code
COPY . .

# Build the project  
RUN npm run build:streamable

# Clean up - remove node_modules and reinstall only production deps
RUN rm -rf node_modules && npm ci --omit=dev

# Expose port (Railway uses PORT env var)
EXPOSE 8976

# Note: Railway handles health checks via the /health endpoint

# Start the HTTP server
CMD ["node", "build/index_http.js"]