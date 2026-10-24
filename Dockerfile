FROM nginx:alpine

# Remove configuração padrão do Nginx
RUN rm -rf /etc/nginx/conf.d/default.conf

# Copia configuração otimizada para SPA/Flutter
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copia diretamente os arquivos compilados do Flutter Web
COPY build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
