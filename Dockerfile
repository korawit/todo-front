FROM node:22-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

# 1. Declare the build argument
ARG VITE_API_URL
# 2. Expose it to the environment for Vite
ENV VITE_API_URL=$VITE_API_URL

# Vite bakes ENV VITE_API_URL into static files here
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf.template /etc/nginx/templates/default.conf.template
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
