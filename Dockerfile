# Use the official OpenJDK 17 image as a base image
FROM openjdk:17-jdk-slim

# Arguments to set up jar file path and other variables if needed
ARG JAR_FILE=target/*.jar

FROM base as build
COPY /* /app/
WORKDIR /app

# Environment variable for Eureka service URL, can be overridden at runtime
ENV EUREKA_SERVER_URL=http://eureka-server:8761/eureka/

RUN mvn install

#calling base like this shrinks the size of the dockerfile
FROM base as release

RUN mkdir /app
WORKDIR /app

COPY --from=build /app/target/ /app/

# Copy the compiled JAR file from the target directory into the image
COPY ${JAR_FILE} app.jar

RUN mv /app/spring-boot-microservice-eureka-naming-server-0.0.1-SNAPSHOT.jar /app/app.jar

EXPOSE 8080


# Specify the command to run on container startup
ENTRYPOINT ["java", "-Dspring.cloud.config.uri=${EUREKA_SERVER_URL}", "-jar", "/app/app.jar"]
