FROM tagt/base:4

ENV RC_VERSION latest

MAINTAINER buildmaster@talk.get

VOLUME /app/uploads

RUN set -x \
 && curl -SLf "https://caoliao.net.cn/releases/${RC_VERSION}/download" -o talk.get.tgz \
 && curl -SLf "https://caoliao.net.cn/releases/${RC_VERSION}/asc" -o talk.get.tgz.asc \
 && gpg --verify talk.get.tgz.asc \
 && tar -zxf talk.get.tgz -C /app \
 && rm talk.get.tgz talk.get.tgz.asc \
 && cd /app/bundle/programs/server \
 && npm install \
 && npm cache clear

USER tagt

WORKDIR /app/bundle

# needs a mongoinstance - defaults to container linking with alias 'mongo'
ENV MONGO_URL=mongodb://mongo:27017/tagt \
    HOME=/tmp \
    PORT=3000 \
    ROOT_URL=http://localhost:3000 \
    Accounts_AvatarStorePath=/app/uploads

EXPOSE 3000

CMD ["node", "main.js"]
