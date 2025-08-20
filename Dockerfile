FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Copy source code first (needed for build)
COPY . .

# Install ALL dependencies (dev dependencies needed for build)
RUN npm install

# Build the project
RUN npm run build:streamable

# Remove dev dependencies after build
RUN npm prune --omit=dev

# Expose port (Railway uses PORT env var)
EXPOSE 8976

# Note: Railway handles health checks via the /health endpoint

# Start the HTTP server
CMD ["node", "build/index_http.js"]