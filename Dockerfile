FROM node:lts as dependencies
WORKDIR /superbase-app
COPY package.json package-lock.json ./
RUN npm install --production

FROM node:lts as builder
WORKDIR /superbase-app
COPY . .
COPY --from=dependencies /superbase-app/node_modules ./node_modules
RUN npm build

FROM node:lts as runner
WORKDIR /supabase-nextjs
ENV NODE_ENV production
# If you are using a custom next.config.js file, uncomment this line.
# COPY --from=builder /superbase-app/next.config.js ./
COPY --from=builder /superbase-app/public ./public
COPY --from=builder /superbase-app/.next ./.next
COPY --from=builder /superbase-app/node_modules ./node_modules
COPY --from=builder /superbase-app/package.json ./package.json

EXPOSE 3000
CMD ["npm", "start"]
