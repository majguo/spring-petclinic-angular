ARG DOCKER_HUB="docker.io"
ARG NGINX_VERSION="1.25.2"
ARG NODE_VERSION="16.14"

FROM $DOCKER_HUB/library/node:$NODE_VERSION as build


COPY . /workspace/

ARG NPM_REGISTRY=" https://registry.npmjs.org"
ARG CONFIG_ENV=
RUN echo "registry = \"$NPM_REGISTRY\"" > /workspace/.npmrc                              && \
    cd /workspace/                                                                       && \
    npm install                                                                          && \
    npm run build -- --configuration $CONFIG_ENV

FROM $DOCKER_HUB/library/nginx:$NGINX_VERSION AS runtime


COPY  --from=build /workspace/dist/ /usr/share/nginx/html/

COPY nginx/nginx.conf.template /etc/nginx/nginx.conf.template
COPY nginx/entrypoint.sh /

ENV REST_APP_URL=http://localhost:9966
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
