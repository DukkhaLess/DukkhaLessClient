FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.g/default.conf
COPY ./dist /usr/share/nginx/html