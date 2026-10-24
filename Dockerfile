# ==========================================
# Estágio 1: Build do Flutter Web
# ==========================================
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Copia dependências primeiro para cache eficiente
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copia todo o código-fonte
COPY . .

# Executa testes automatizados durante a esteira de build
RUN flutter test

# Compila o Flutter Web em modo release com CanvasKit / HTML otimizado
RUN flutter build web --release --pwa-strategy=none

# ==========================================
# Estágio 2: Servidor Web Nginx Leve para Produção
# ==========================================
FROM nginx:alpine

# Remove configuração padrão do Nginx
RUN rm -rf /etc/nginx/conf.d/default.conf

# Copia configuração customizada otimizada para SPA/Flutter
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copia artefatos compilados do estágio anterior
COPY --from=build /app/build/web /usr/share/nginx/html

# Expõe porta padrão HTTP
EXPOSE 80

# Healthcheck nativo para o Coolify monitorar status da aplicação
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget -q --spider http://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
