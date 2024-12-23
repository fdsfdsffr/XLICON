# Use a Debian Buster base image
FROM debian:buster

# Install dependencies and Node.js 23
RUN apt-get update && \
  apt-get install -y \
  curl \
  ffmpeg \
  imagemagick \
  webp && \
  curl -sL https://deb.nodesource.com/setup_23.x | bash - && \
  apt-get install -y nodejs && \
  apt-get upgrade -y && \
  rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy package.json first
COPY package.json ./ 

# Copy package-lock.json if available
COPY package-lock.json* ./ 

# Install Node.js dependencies
RUN npm install

# Copy all files to the container
COPY . . 

# Expose port 5000 for your app
EXPOSE 5000

# Copy the start script and make it executable
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Run the start script
CMD ["/app/start.sh"]
