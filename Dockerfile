
FROM node:16-alpine

RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app

WORKDIR /home/node/app

COPY package*.json ./

RUN mkdir src
COPY src/* ./src

RUN mkdir bin
COPY bin/* ./bin

RUN ls bin

RUN ls src

USER node

RUN npm install

COPY --chown=node:node . .

EXPOSE 3000

CMD [ "node", "src/000.js" ]
