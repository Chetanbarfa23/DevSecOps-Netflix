FROM node:20-alpine AS builder

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install

COPY . .

ARG TMDB_V3_API_KEY
ENV VITE_APP_TMDB_V3_API_KEY=${TMDB_V3_API_KEY}
ENV VITE_APP_API_ENDPOINT_URL="https://api.themoviedb.org/3"

RUN yarn build

FROM nginx:stable-alpine

RUN addgroup -S nginxapp && adduser -S -G nginxapp nginxapp

WORKDIR /usr/share/nginx/html

RUN rm -rf ./*

COPY --from=builder /app/dist .
COPY nginx-main.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/cache/nginx /var/log/nginx /run/nginx &&     chown -R nginxapp:nginxapp       /usr/share/nginx/html       /var/cache/nginx       /var/log/nginx       /run/nginx       /etc/nginx

EXPOSE 8080

USER nginxapp

ENTRYPOINT ["nginx", "-g", "daemon off;"]
