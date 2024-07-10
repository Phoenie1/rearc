
FROM node:10

RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app

WORKDIR /home/node/app

COPY package*.json ./

RUN mkdir src
COPY src/* ./src

RUN mkdir bin
COPY bin/* ./bin

ENV SECRET_WORD="TwelveFactor"

USER node

RUN npm install

COPY --chown=node:node . .

EXPOSE 3000

CMD [ "node", "src/000.js" ]
