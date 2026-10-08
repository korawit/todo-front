# --- Stage 1: Build Stage ---
FROM node:22-alpine AS build

WORKDIR /app

# Copy package descriptors first to leverage Docker layer caching
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the application code
COPY . .

# Build the static distribution assets
RUN npm run build

# --- Stage 2: Production Stage ---
FROM nginx:alpine

# Copy built assets from Stage 1 to Nginx default public folder
# (Change 'dist' to 'build' if your output directory is named 'build')
COPY --from=build /app/dist /usr/share/nginx/html

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
