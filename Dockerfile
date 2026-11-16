FROM node:22-alpine

RUN apk add --no-cache nginx

WORKDIR /app

COPY backend/package*.json ./backend/
RUN cd backend && npm ci --omit=dev

COPY backend/ ./backend/
COPY frontend/ ./frontend/

COPY nginx.conf /etc/nginx/http.d/default.conf

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 80

CMD ["/start.sh"]

