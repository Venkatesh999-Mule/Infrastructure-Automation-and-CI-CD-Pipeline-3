FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
COPY target/infra-pipeline-1.0.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]