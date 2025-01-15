FROM node:lts-alpine AS build-stage

RUN apt-get update && apt-get install -y bash

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

FROM nginx:stable-perl AS production-stage

WORKDIR /app

COPY --from=build-stage /app/dist /usr/share/nginx/html

#COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
