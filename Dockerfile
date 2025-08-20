FROM node:18-alpine

# Install TypeScript globally
RUN npm install -g typescript

WORKDIR /app

# Copy package files
COPY package*.json ./

# Copy source code
COPY . .

# Install all dependencies (including dev for build)
RUN npm install

# Build the project with global tsc
RUN npm run build:streamable

# Clean install production dependencies only
RUN rm -rf node_modules && npm ci --omit=dev

# Expose port (Railway uses PORT env var)
EXPOSE 8976

# Note: Railway handles health checks via the /health endpoint

# Start the HTTP server
CMD ["node", "build/index_http.js"]