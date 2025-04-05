# ---- Build Stage ----
FROM maven:3.9.9-amazoncorretto-8-al2023 AS build
WORKDIR /app
# Copy Maven files and source code
COPY pom.xml .
COPY src/ ./src/
# Build the application and skip tests for faster builds
RUN mvn clean package -DskipTests

# ---- Run Stage ----
FROM openjdk:21-slim
WORKDIR /app
# Copy the packaged jar from the build stage (adjust the pattern if your jar name differs)
COPY --from=build /app/target/*.jar app.jar
# Informational: exposing the port on which the app listens internally (Spring Boot defaults to 8080)
EXPOSE 8081
# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
