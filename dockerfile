# Dockerfile

# --- ETAPA 1: Build da Aplicação Angular ---
# Usamos uma imagem oficial do Node.js como base. A tag "-alpine" usa uma versão mais leve do Linux.
FROM node:20-alpine AS builder

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copia os arquivos de definição de dependências
# Isso aproveita o cache do Docker. Se esses arquivos não mudarem, o 'npm install' não será executado novamente.
COPY package.json package-lock.json ./

# Instala as dependências do projeto
RUN npm install

# Copia o restante do código-fonte da aplicação para o contêiner
COPY . .

# Compila a aplicação Angular para produção.
# O resultado será salvo na pasta /app/dist/my-first-angular
RUN npm run build


# --- ETAPA 2: Servidor de Produção ---
# Usamos uma imagem oficial e leve do Nginx para servir os arquivos.
FROM nginx:stable-alpine

# Remove a configuração padrão do Nginx
RUN rm /etc/nginx/conf.d/default.conf

# Copia nossa configuração personalizada do Nginx (vamos criar este arquivo no próximo passo)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copia os arquivos compilados da etapa 'builder' para a pasta pública do Nginx
COPY --from=builder /app/dist/my-first-angular/ /usr/share/nginx/html

# Expõe a porta 80, que é a porta padrão do Nginx
EXPOSE 80

# Comando para iniciar o servidor Nginx quando o contêiner for executado
CMD ["nginx", "-g", "daemon off;"]