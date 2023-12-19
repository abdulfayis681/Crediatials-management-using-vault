# Stage 1
FROM node:14 as build-stage

WORKDIR /FRONTEND-SOURCE-CODE
COPY package.json .
RUN npm install
COPY . .

RUN npm run build


# Stage 2
FROM nginx:1.17.0-alpine

COPY --from=build-stage /FRONTEND-SOURCE-CODE/build /usr/share/nginx/html
EXPOSE 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]

