FROM nginx:latest
COPY public /usr/share/nginx/html
COPY public/sitemap.xml /usr/share/nginx/html/sitemap.xml
COPY conf/nginx.conf /etc/nginx/nginx.conf
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]