### STAGE 1: Build ###
FROM node:12.7-alpine AS build

WORKDIR /usr/src/app

# Copier les fichiers de dépendances en premier (optimise le cache Docker)
COPY package.json package-lock.json ./

RUN npm install

# Copier le reste du projet
COPY . .

# Builder l'application Angular
RUN npm run build

### STAGE 2: Run ###
FROM nginx:1.17.1-alpine

# Copier la configuration nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Copier les fichiers buildés depuis le stage 1
COPY --from=build /usr/src/app/dist/aston-villa-app /usr/share/nginx/html

