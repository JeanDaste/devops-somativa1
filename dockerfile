# Dockerfile

# --- ETAPA 1: Build da Aplicação Angular ---
FROM node:20-alpine AS builder

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copia os arquivos de definição de dependências
COPY package.json package-lock.json ./

# Instala as dependências do projeto
RUN npm install

# Copia o restante do código-fonte da aplicação para o contêiner
COPY . .

# Compila a aplicação Angular para produção
RUN npm run build


# --- ETAPA 2: Servidor de Produção ---
FROM nginx:stable-alpine

# Remove a configuração padrão do Nginx
RUN rm /etc/nginx/conf.d/default.conf

# Copia nossa configuração personalizada do Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copia os arquivos compilados da etapa 'builder' para a pasta pública do Nginx
# <-- ESTA É A LINHA CORRIGIDA
COPY --from=builder /app/dist/my-first-angular/browser/ /usr/share/nginx/html

# Expõe a porta 80, que é a porta padrão do Nginx
EXPOSE 80

# Comando para iniciar o servidor Nginx quando o contêiner for executado
CMD ["nginx", "-g", "daemon off;"]