# Stage 1: Build với Maven
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Stage 2: Runtime (Sử dụng Distroless hoặc Alpine để giảm diện tích tấn công)
FROM eclipse-temurin:17-jre-alpine
# THÊM DÒNG NÀY: Cập nhật các bản vá OS mới nhất (sửa lỗi zlib, gnutls)
RUN apk update && apk upgrade --no-cache && rm -rf /var/cache/apk/*
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring 
# Tại sao? Chạy App bằng user thường, không dùng ROOT.

WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]