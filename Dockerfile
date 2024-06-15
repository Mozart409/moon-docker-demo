FROM node:20-bookworm-slim
WORKDIR /app

# Install moon binary
RUN npm install -g @moonrepo/cli

# Update CA certificates
RUN apt-get update && apt-get install -y ca-certificates

# Copy workspace skeleton
COPY ./.moon/docker/workspace .

# Install toolchain and dependencies
RUN moon docker setup

# Copy source files
COPY ./.moon/docker/sources .

# Run something
RUN moon run strapi:build 

# Prune workspace
RUN moon docker prune

# Expose port
EXPOSE 1337

CMD ["moon", "run", "strapi:start"]
