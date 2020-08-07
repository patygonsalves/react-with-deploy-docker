# imagem de origem
FROM node:10.15.3 AS build

# onde a aplicacao ficará dentro do container
WORKDIR ./

COPY . .

# instalando dependências da aplicacao
RUN npm install

# build da aplicacao
RUN npm run build

# ambiente de produção
FROM nginx:1.17.6-alpine
ARG HOST
ENV HOST_FRONT=$HOST \
  ESC='$'
COPY --from=build ./build /usr/share/nginx/html/
COPY ./nginx/nginx.model /etc/nginx/conf.d/nginx.model

# porta usada pela imagem
EXPOSE 4013

# start app
CMD ["/bin/sh", "-c", "envsubst < /etc/nginx/conf.d/nginx.model > /etc/nginx/nginx.conf && nginx -g 'daemon off;'"]
