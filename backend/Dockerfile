FROM node:18.19.0-alpine3.19

WORKDIR /app

COPY package.json .
COPY package-lock.json .

RUN npm ci --only=production 

COPY . .

CMD [ "npm", "run", "start" ]

# CMD ["node", "app.js"]

EXPOSE 3001

