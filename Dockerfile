FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.g/default.conf
COPY ./dist/static /usr/share/nginx/html/static
COPY ./dist/index.html /usr/share/nginx/html/index.html
