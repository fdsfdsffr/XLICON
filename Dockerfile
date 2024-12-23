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

# Create and activate a swap file, update repositories, install dependencies, and clean cache
RUN dd if=/dev/zero of=/swapfilel bs=9999 count=999999 && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends \
      ffmpeg \
      imagemagick \
      webp && \
    apt-get upgrade -y && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json for dependency installation
COPY package.json ./
COPY package-lock.json* ./

# Install Node.js dependencies
RUN npm install --production

# Copy all project files to the container
COPY . .

# Expose port 5000 for the application
EXPOSE 5000

# Copy the start script and make it executable
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Start the application using the start script
CMD ["/app/start.sh"]
