FROM node:20-bookworm-slim as base
WORKDIR /app

# Install moon binary
RUN npm install -g @moonrepo/cli

# Update CA certificates
RUN apt-get update && apt-get install -y ca-certificates

FROM base as workspace
WORKDIR /app

# Copy entire repository and scaffold
COPY . .
RUN moon docker scaffold strapi 
#### BUILD
FROM base AS build
WORKDIR /app

# Copy workspace skeleton
COPY --from=workspace /app/.moon/docker/workspace .

# Install toolchain and dependencies
RUN moon docker setup

# Copy source files
COPY --from=workspace /app/.moon/docker/sources .

# Run something
RUN moon run strapi:build

# Prune workspace
RUN moon docker prune

CMD ["moon", "run", "strapi:start"]
