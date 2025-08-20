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

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD node -e "fetch('http://localhost:' + (process.env.PORT || 8976) + '/health').then(r => r.ok ? process.exit(0) : process.exit(1)).catch(() => process.exit(1))"

# Start the HTTP server
CMD ["node", "build/index_http.js"]