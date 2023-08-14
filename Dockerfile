# Use the official OpenJDK 17 image as a base image
FROM openjdk:17-jdk-slim

# Arguments to set up jar file path and other variables if needed
ARG JAR_FILE=target/*.jar

# Environment variable for Eureka service URL, can be overridden at runtime
ENV EUREKA_SERVER_URL=http://eureka-server:8761/eureka/

# Copy the compiled JAR file from the target directory into the image
COPY ${JAR_FILE} app.jar

# Specify the command to run on container startup
ENTRYPOINT ["java", "-Dspring.cloud.config.uri=${EUREKA_SERVER_URL}", "-jar", "/app.jar"]
