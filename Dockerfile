# NOTE:
# Docker is not a Node.js package manager.
# Please ensure Docker is already installed on your system.
# Follow official instructions at https://docs.docker.com/desktop/
# Official Node.js Docker images: https://github.com/nodejs/docker-node

# Pull Node.js v22-alpine (lightweight version of Node.js)
FROM node:22-alpine

# Verify the correct Node.js version in the environment
# Expected: v22.12.0
RUN node -v

# Verify the correct npm version in the environment
# Expected: 10.9.0
RUN npm -v

# Set environment to production
ENV NODE_ENV=production

# Update system and install required dependencies
RUN apk add --no-cache \
    ffmpeg \
    imagemagick \
    libwebp && \
    rm -rf /var/cache/apk/*

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json for dependency installation
COPY package.json package-lock.json* ./

# Install Node.js dependencies
RUN npm ci --production

# Copy all project files to the container
COPY . .

# Expose port 5000 for the application
EXPOSE 5000

# Copy the start script and make it executable
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Start the application using the start script
CMD ["/app/start.sh"]
