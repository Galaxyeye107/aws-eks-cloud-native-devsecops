# Stage 1: Build Angular App
FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
# Sửa lại dòng số 5 trong Stage 1
RUN npm install --ignore-scripts
COPY . .
RUN npm run build --configuration=production

# Stage 2: Serve với Nginx (Bản Alpine để giảm thiểu lỗ hổng)
FROM nginx:alpine
RUN apk update && apk upgrade --no-cache


# Copy file cấu hình Nginx tùy chỉnh (Xem bước dưới để tạo file này)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Bảo mật: Đổi chủ sở hữu thư mục cache và pid để Nginx chạy được với user thường
RUN touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid /var/cache/nginx /var/log/nginx /etc/nginx/conf.d

# Chuyển sang dùng User nginx (đã có sẵn trong image alpine)
USER nginx

# Copy file đã build từ stage 1
COPY --from=build /app/dist/angular-ecommerce /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]