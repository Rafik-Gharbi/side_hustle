FROM node:18.19.0-alpine3.19

WORKDIR /app

COPY package.json .
COPY package-lock.json .

RUN apk --no-cache add build-base python3
RUN npm ci --only=production
RUN npm rebuild bcrypt --build-from-source

COPY . .

CMD [ "npm", "run", "start" ]

# CMD ["node", "app.js"]

EXPOSE 3001

